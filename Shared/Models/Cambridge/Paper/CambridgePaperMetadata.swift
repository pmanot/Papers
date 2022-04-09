//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

extension PDFDocument {
    func pages() -> [PDFPage] {
        (0..<self.pageCount - 1).compactMap { self.page(at: $0) }
    }
}

enum PaperCodeError: Error {
    case invalidCode
}

struct CambridgePaperMetadata: Codable, Hashable {
    let code: String
    let type: CambridgePaperType
    let kind: CambridgePaperKind
    var pages: [CambridgePaperPage] = []
    
    init(url: URL) throws {
        self.code = url.deletingPathExtension().lastPathComponent
        self.type = CambridgePaperType(paperCode: code)
        self.kind = CambridgePaperKind(paperCode: code)
    }
    
    mutating func getPages(url: URL) -> () {
        guard let pdf = PDFDocument(url: url) else {
            return
        }
        
        let pages = pdf.pages()
        
        switch kind {
            case .longAnswer:
                var questionIndexValue = 0
                var partIndexValue = 0
                var numeralIndexValue = 0
                
                for page in pages {
                    let contents = AttributedString(page.attributedString!)

                    let questionIndices = getQuestionIndicesFromPage(
                        page,
                        currentIndex: &questionIndexValue,
                        currentLetterIndex: &partIndexValue,
                        currentNumeralIndex: &numeralIndexValue
                    )
                    
                    self.pages.append(CambridgePaperPage(questionIndices: questionIndices, contents: contents))
                }
            default:
                return
        }
    }
}

extension CambridgePaperMetadata {
    private static func validatePaperCode(_ code: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: RegularExpressions.paperCodePattern)
        return regex.matches(code)
    }
}

// Question Index that holds data about nested indices inside a question
struct QuestionIndex: Hashable, Codable {
    let index: Int
    let type: QuestionIndexType
    var parts: [QuestionIndex] = []
}

enum QuestionIndexType: Hashable, Codable {
    case number, letter, numeral, subNumber
}



func getQuestionIndicesFromPage(
    _ page: PDFPage,
    currentIndex: inout Int,
    currentLetterIndex: inout Int,
    currentNumeralIndex: inout Int
) -> [QuestionIndex] {
    guard let contents = page.attributedString else {
        return []
    }
    //print("-------NEW PAGE-------")
    var partsDictionary = [Int: [Int]]()
    let boldStrings = contents
        .fetchBoldStrings()
        .reduce("", +)
    
    let regexNum = try! NSRegularExpression(pattern: "[0-9]+")
    let regexParts = try! NSRegularExpression(pattern: "\\([a-z]+\\)")
    let numbers = regexNum
        .returnMatches(boldStrings)
        .compactMap(Int.init)
    
    let partsArray = regexParts
        .returnMatches(boldStrings)
        .map { $0.removingCharacters(in: CharacterSet(charactersIn: "()")) }
    
    
    
    if numbers.contains(currentIndex + 1) {
        currentIndex += 1
        //print("Question \(index)")
        currentLetterIndex = 0
        currentNumeralIndex = 0
    }
    
    if currentIndex >= 1 {
        //print("index >= 1")
        for part in partsArray {
            print(part)
            if part == PapersDatabase.letters[currentLetterIndex] {
                partsDictionary[currentLetterIndex + 1] = []
                currentLetterIndex += 1
                currentNumeralIndex = 0
                //print(partsDictionary)
            } else if part == PapersDatabase.numerals[currentNumeralIndex] {
                //print("matched \(part)")
                if partsDictionary[currentLetterIndex].isNilOrEmpty {
                    partsDictionary[currentLetterIndex] = []
                }
                partsDictionary[currentLetterIndex]!.append(currentNumeralIndex + 1)
                //print(partsDictionary)
                currentNumeralIndex += 1
            }
        }
    }
    //print("----------------------")
    
    let parts = partsDictionary
        .map { (key, value) in
            QuestionIndex(index: key, type: .letter, parts: value.map({ QuestionIndex(index: $0, type: .numeral) }) )
        }
    
    return [QuestionIndex(index: currentIndex, type: .number, parts: parts)]
}

/*
struct CambridgePaperMetadata: Codable, Hashable {
    static let paperCodePattern = "[0-9]{4}_[a-z]{1}[0-9]{2}_[a-z]{2}_[0-9]{2}"
    
    let paperCode: String
    let questionPaperCode: String
    let paperType: CambridgePaperType
    let month: CambridgePaperMonth
    let year: Int
    let subject: CambridgeSubject
    let paperNumber: CambridgePaperNumber
    let paperVariant: CambridgePaperVariant
    var pageData: [CambridgePaperPage] = []
    var answers: [Answer] = []
    var numberOfQuestions: Int = 0
    var rawText: String = ""
    var error: Bool = false
    
    
    
    init(url: URL){
        self.init(paperCode: url.deletingPathExtension().lastPathComponent)
        fetchPageData(pdf: PDFDocument(url: url)!)
        self.rawText = pageData.map { $0.rawText }.reduce("", +)
    }
    
    init(bundleResourceName: String){
        self.init(url: URL(fileURLWithPath: Bundle.main.path(forResource: bundleResourceName, ofType: "pdf")!))
    }
    
    mutating func fetchPageData(pdf: PDFDocument) {
        switch paperType {
        case .markScheme:
                switch subject {
                    case .chemistry, .physics, .biology:
                        switch paperNumber {
                            case .paper1: // paper 1 (mcq)
                                if self.year >= 17 {
                                    var multipleChoiceAnswerArray: [AnswerValue] = [] // initialize empty array that will store extracted answers from mcq
                                    for i in 1..<pdf.pageCount {
                                        let pageNumber = i + 1
                                        let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                                        let rawPageText = page.string ?? "" // extract text from the page
                                        pageData.append(CambridgePaperPage(type: .markSchemePage, rawText: rawPageText, pageNumber: pageNumber))
                                        
                                        var numberOfAnswers: Int {
                                            i == 1 ? 28 : 12
                                        }
                                        
                                        let snapshot = getImagefromURL(url: pdf.documentURL!, pageNumber: pageNumber)!.cgImage
                                        
                                        if snapshot == nil {
                                            print("This is a problematic snapshot: \(self.paperCode), page: \(pageNumber)")
                                            error = true
                                            print("error toggled due to nil snapshot error")
                                            break
                                        }
                                        
                                        for n in 0..<numberOfAnswers {
                                            if let croppedImage = snapshot!.cropping(to: CGRect(origin: CGPoint(x: 230, y: 177 + 49*n), size: CGSize(width: 74, height: 45))){
                                                let choice = recogniseAllText(from: croppedImage, .accurate, lookFor: ["A", "B", "C", "D"]).removing(allOf: " ")
                                                print(choice)
                                                if ["A", "B", "C", "D"].contains(choice) {
                                                    multipleChoiceAnswerArray.append(.multipleChoice(choice: MCQSelection(rawValue: choice)!))
                                                }
                                            }
                                            print(n)
                                        }
                                    }
                                    
                                    if multipleChoiceAnswerArray.length == 40 {
                                        answers = [Int](1...40).map { Answer(index: QuestionIndex($0), value: multipleChoiceAnswerArray[$0 - 1]) }
                                    } else {
                                        print(multipleChoiceAnswerArray)
                                        error = true
                                        print("error toggled due to MCQ answer detection problem")
                                    }
                                } else {
                                    for i in 1..<pdf.pageCount {
                                        let pageNumber = i + 1
                                        let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                                        let rawPageText = page.string ?? "" // extract text from the page
                                        pageData.append(CambridgePaperPage(type: .markSchemePage, rawText: rawPageText, pageNumber: pageNumber))
                                    }
                                }
                                
                            default: // paper 4
                                for i in 1..<(pdf.pageCount - 1) {
                                    let pageNumber = i + 1
                                    let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                                    let rawPageText = page.string ?? "" // extract text from the page
                                    pageData.append(CambridgePaperPage(type: .markSchemePage, rawText: rawPageText, pageNumber: pageNumber))
                                }
                        }
                    default:
                        for i in 1..<(pdf.pageCount - 1) {
                            let pageNumber = i + 1
                            let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                            let rawPageText = page.string ?? "" // extract text from the page
                            pageData.append(CambridgePaperPage(type: .markSchemePage, rawText: rawPageText, pageNumber: pageNumber))
                        }
                        
                }
        case .questionPaper:
                switch subject {
                    case .chemistry, .physics, .biology:
                        switch paperNumber {
                            case .paper1: // paper 1 (mcq)
                                for i in 0..<pdf.pageCount {
                                    let pageNumber = i + 1
                                    let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                                    let rawPageText = page.string ?? "" // extract text from the page
                                    pageData.append(CambridgePaperPage(type: .multipleChoicePage(indexes: []), rawText: rawPageText, pageNumber: pageNumber))
                                }
                                self.numberOfQuestions = 40 // Cambridge A level MCQ Papers always contain 40 questions
                                
                            default: // paper 4
                                var nextQuestionNumber: Int = 1 // question number to look for
                                var runningQuestionNumber: Int = 0 // current question number (last question number detected)
                                var startingPage: Int {
                                    switch self.subject {
                                        case .physics:
                                            switch self.paperNumber {
                                                case .paper1, .paper2, .paper4:
                                                    return 3
                                                default:
                                                    return 1
                                            }
                                        default:
                                            return 1
                                    }
                                }
                                
                                for i in startingPage..<pdf.pageCount {
                                    let pageNumber = i + 1
                                    let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                                    let rawPageText = page.string ?? "" // extract text from the page
                                    
                                    if rawPageText.contains("BLANK PAGE") { // check for blank page
                                        pageData.append(CambridgePaperPage(type: .blank, rawText: "", pageNumber: pageNumber))
                                    } else {
                                        // alt
                                        //var snapshot = page.thumbnail(of: CGSize(width: page.bounds(for: .cropBox).size.width, height: page.bounds(for: .cropBox).size.height), for: .cropBox)
                                        // regular
                                        switch self.paperNumber {
                                            case .paper3, .paper5:
                                                if runningQuestionNumber == 2 {
                                                    let index = QuestionIndex(runningQuestionNumber)
                                                    pageData.append(CambridgePaperPage(type: .questionPaperPage(index: index), rawText: rawPageText, pageNumber: pageNumber))
                                                } else {
                                                    let snapshot = getImagefromURL(url: pdf.documentURL!, pageNumber: pageNumber)!.cgImage
                                                    
                                                    if snapshot == nil {
                                                        print("This is a problematic snapshot: \(self.paperCode), page: \(pageNumber)")
                                                        error = true
                                                        print("error toggled due to nil snapshot error")
                                                    }
                                                    // let croppedSnapshot = snapshot!.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 200)))! // crop page snapshot to only include question number
                                                    let croppedSnapshot = snapshot!.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 140, height: 400)))! // crop page snapshot to only include page number
                                                    
                                                    let recognisedText = recogniseAllText(from: croppedSnapshot, .accurate, lookFor: [0...15].map {"\($0)"})
                                                    print("This should be the question number: ", recognisedText, "in paper \(self.paperCode) page \(pageNumber)")
                                                    
                                                    if recognisedText.contains("\(nextQuestionNumber)"){ // check if the page containes a new question (the next question)
                                                        runningQuestionNumber = nextQuestionNumber
                                                        nextQuestionNumber += 1
                                                        
                                                        let index = QuestionIndex(runningQuestionNumber)
                                                        pageData.append(CambridgePaperPage(type: .questionPaperPage(index: index), rawText: rawPageText, pageNumber: pageNumber))
                                                         // debugging

                                                        
                                                    } else { //continuation of previous question
                                                        let index = QuestionIndex(runningQuestionNumber)
                                                        pageData.append(CambridgePaperPage(type: .questionPaperPage(index: index), rawText: rawPageText, pageNumber: pageNumber))
                                                         // debugging
                                                    }
                                                }
                                            default:
                                                // alt
                                                //var snapshot = page.thumbnail(of: CGSize(width: page.bounds(for: .cropBox).size.width, height: page.bounds(for: .cropBox).size.height), for: .cropBox)
                                                // regular
                                                let snapshot = getImagefromURL(url: pdf.documentURL!, pageNumber: pageNumber)!.cgImage
                                                
                                                if snapshot == nil {
                                                    print("This is a problematic snapshot: \(self.paperCode), page: \(pageNumber)")
                                                    error = true
                                                    print("error toggled due to nil snapshot error")
                                                }
                                                
                                                
                                                // let croppedSnapshot = snapshot!.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 200)))! // crop page snapshot to only include question number
                                                let croppedSnapshot = snapshot!.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 140, height: 400)))! // crop page snapshot to only include page number
                                                
                                                let recognisedText = recogniseAllText(from: croppedSnapshot, .accurate, lookFor: [0...15].map {"\($0)"})
                                                print("This should be the question number: ", recognisedText, "in paper \(self.paperCode) page \(pageNumber)")
                                                
                                                if recognisedText.contains("\(nextQuestionNumber)"){ // check if the page containes a new question (the next question)
                                                    runningQuestionNumber = nextQuestionNumber
                                                    nextQuestionNumber += 1
                                                    
                                                    let index = QuestionIndex(runningQuestionNumber)
                                                    pageData.append(CambridgePaperPage(type: .questionPaperPage(index: index), rawText: rawPageText, pageNumber: pageNumber))
                                                     // debugging

                                                    
                                                } else { //continuation of previous question
                                                    let index = QuestionIndex(runningQuestionNumber)
                                                    pageData.append(CambridgePaperPage(type: .questionPaperPage(index: index), rawText: rawPageText, pageNumber: pageNumber))
                                                     // debugging
                                                }
                                        }
                                        
                                    }
                                }
                                numberOfQuestions = runningQuestionNumber
                        }
                    default:
                        switch paperNumber {
                            default: // paper 4
                                var nextQuestionNumber: Int = 1 // question number to look for
                                var runningQuestionNumber: Int = 0 // current question number (last question number detected)
                                var startingPage: Int {
                                    switch self.subject {
                                        case .physics:
                                            switch self.paperNumber {
                                                case .paper1:
                                                    return 3
                                                case .paper2:
                                                    return 3
                                                case .paper4:
                                                    return 3
                                                default:
                                                    return 1
                                            }
                                        default:
                                            return 1
                                    }
                                }
                                
                                for i in startingPage..<pdf.pageCount {
                                    let pageNumber = i + 1
                                    let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                                    let rawPageText = page.string ?? "" // extract text from the page
                                    
                                    if rawPageText.contains("BLANK PAGE") { // check for blank page
                                        pageData.append(CambridgePaperPage(type: .blank, rawText: "", pageNumber: pageNumber))
                                    } else {
                                        let snapshot = getImagefromURL(url: pdf.documentURL!, pageNumber: pageNumber)!.cgImage
                                        
                                        if snapshot == nil {
                                            print("This is a problematic snapshot: \(self.paperCode), page: \(pageNumber)")
                                            error = true
                                            print("error toggled due to nil snapshot error")
                                        }
                                        
                                        
                                        // let croppedSnapshot = snapshot!.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 200)))! // crop page snapshot to only include question number
                                        let croppedSnapshot = snapshot!.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 140, height: 400)))! // crop page snapshot to only include page number
                                        
                                        let recognisedText = recogniseAllText(from: croppedSnapshot, .accurate, lookFor: [0...15].map {"\($0)"})
                                        print("This should be the question number: ", recognisedText, "in paper \(self.paperCode) page \(pageNumber)")
                                        
                                        if recognisedText.contains("\(nextQuestionNumber)"){ // check if the page containes a new question (the next question)
                                            runningQuestionNumber = nextQuestionNumber
                                            nextQuestionNumber += 1
                                            
                                            let index = QuestionIndex(runningQuestionNumber)
                                            pageData.append(CambridgePaperPage(type: .questionPaperPage(index: index), rawText: rawPageText, pageNumber: pageNumber))
                                             // debugging

                                            
                                        } else { //continuation of previous question
                                            let index = QuestionIndex(runningQuestionNumber)
                                            pageData.append(CambridgePaperPage(type: .questionPaperPage(index: index), rawText: rawPageText, pageNumber: pageNumber))
                                             // debugging
                                        }
                                    }
                                }
                                numberOfQuestions = runningQuestionNumber
                        }
                        
                }
        case .datasheet:
            for i in 0..<pdf.pageCount {
                let pageNumber = i + 1
                let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                let rawPageText = page.string ?? "" // extract text from the page
                pageData.append(CambridgePaperPage(type: .datasheet, rawText: rawPageText, pageNumber: pageNumber))
            }
        case .other:
            pageData += [] // do nothing
        }
    }
}

extension Array where Element == CambridgePaperMetadata {
    func matching(_ url: URL) -> CambridgePaperMetadata? {
        self.first { $0.paperCode == url.getPaperCode() }
    }
}

func getQuestionPaperCode(_ paperCode: String) -> String {
    var extendedPaperCode: String = ""
    let paperCodeChunks = paperCode.split(separator: "_")
    extendedPaperCode += "\(paperCodeChunks[0])/"
    extendedPaperCode += "\(paperCodeChunks[3])/"
    switch paperCodeChunks[1].dropLast(2) {
    case "s":
        extendedPaperCode += "M/J/"
    case "w":
        extendedPaperCode += "O/N/"
    case "m":
        extendedPaperCode += "F/M/"
    default:
        extendedPaperCode += "F/M/"
    }
    extendedPaperCode += "\(paperCodeChunks[1].dropFirst())"
    
    return extendedPaperCode
}
*/
