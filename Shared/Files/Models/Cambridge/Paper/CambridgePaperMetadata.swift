//
// Copyright (c) Purav Manot
//

import Diagnostics
import Foundation
import PDFKit

extension PDFDocument {
    func pages() -> [PDFPage] {
        (0..<self.pageCount).compactMap { self.page(at: $0) }
    }
}

enum PaperCodeError: Error {
    case invalidCode
}

struct CambridgePaperMetadata: Codable, Hashable {
    static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "CambridgePaperMetadata")
    
    let code: String
    let type: CambridgePaperType
    var pages: [CambridgePaperPage] = []
    var details: CambridgePaperDetails {
        CambridgePaperDetails.init(paperCode: code)
    }
    var kind: CambridgePaperKind {
        CambridgePaperKind(details: details)
    }
    
    var multipleChoiceAnswers: [QuestionIndex : MultipleChoiceAnswer] = [:]
    
    /// COMPATIBILITY
    var answers: [Answer] = []
    var numberOfQuestions: Int = 40
    var rawText: String {
        self.pages.map { $0.rawText }.reduce("", +)
    }
    var indices: [QuestionIndex] = []
    
    var questionPaperCode: String {
        getQuestionPaperCode(code)
    }
    
    var paperNumber: CambridgePaperNumber {
        self.details.number ?? .paper1
    }
    var paperVariant: CambridgePaperVariant {
        self.details.variant ?? .variant1
    }
    var subject: CambridgeSubject {
        self.details.subject ?? .other
    }
    var month: CambridgePaperMonth {
        self.details.month ?? .mayJune
    }
    var year: Int {
        self.details.year ?? 2020
    }
    
    ///-------------------------------
    
    init(url: URL) {
        self.code = url.deletingPathExtension().lastPathComponent
        self.type = CambridgePaperType(paperCode: code)
        getPages(url: url)
    }
    
    init(code: String){
        if regexMatches(string: code, pattern: RegularExpressions.paperCodePattern) { // check if papercode is valid
            self.code = code
            self.type = CambridgePaperType(paperCode: code)
        } else { // papercode is not valid
            self.code = code
            self.type = .other
        }
    }
    
    init(bundleResourceName: String){
        self.init(url: URL(fileURLWithPath: Bundle.main.path(forResource: bundleResourceName, ofType: "pdf")!))
    }
    
    mutating func getPages(url: URL) -> () {
        guard let pdf = PDFDocument(url: url) else {
            return
        }
        
        let pages = pdf.pages()
        
        Self.logger.debug("Parsing pages from PDF at \(url)")
        
        switch kind {
            case .longAnswer:
                var startingPage: Int {
                    switch self.subject {
                        case .physics:
                            switch self.details.number {
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
                Self.logger.debug("Parsing long answers.")

                var questionIndexValue = 1
                var partIndexValue = 0
                var numeralIndexValue = 0
                
                for page in pages {
                    let index = page.pageRef?.pageNumber ?? 0
                    let rawText = page.string ?? ""
                    
                    if index <= startingPage  { // First Page
                        self.pages.append(CambridgePaperPage(index: index, questionIndices: [], rawText: rawText))
                    } else {
                        let questionIndices = page.getQuestionIndices(
                            currentIndex: &questionIndexValue,
                            currentLetterIndex: &partIndexValue,
                            currentNumeralIndex: &numeralIndexValue
                        )

                        Self.logger.debug("Current question index \(questionIndices[0].index).")
                        Self.logger.debug("Current page number \(index).")
                        
                        self.pages.append(CambridgePaperPage(index: index, questionIndices: questionIndices, rawText: rawText))
                    }
                }
                self.indices = combine(self.pages.map { $0.questionIndices }.reduce([], +))
                self.numberOfQuestions = questionIndexValue
                
                Self.logger.debug("Parsed \(questionIndexValue) question(s).")
            case .multipleChoice:
                switch type {
                    case .questionPaper:
                        self.pages = pages.map { CambridgePaperPage(index: $0.pageRef?.pageNumber ?? 0, questionIndices: [], rawText: $0.string ?? "") }
                        return
                    case .markScheme:
                        for page in pages {
                            let index = page.pageRef?.pageNumber ?? 0
                            let rawText = page.string!

                            switch index {
                                case 1: // First Page
                                    self.pages.append(CambridgePaperPage(index: index, questionIndices: [], rawText: rawText))
                                case 2:
                                    self.pages.append(CambridgePaperPage(index: index, questionIndices: [Int](1...28).map { QuestionIndex($0) }, rawText: rawText))
                                    multipleChoiceAnswers.append(contentsOf: page.getAnswers(for: 1...28))
                                case 3:
                                    self.pages.append(CambridgePaperPage(index: index, questionIndices: [Int](29...40).map { QuestionIndex($0) }, rawText: rawText))
                                    multipleChoiceAnswers.append(contentsOf: page.getAnswers(for: 29...40))
                                    
                                    let log = "MCQ answers calculated (\(multipleChoiceAnswers.count) answers) for Paper \(self.code)"
                                    Self.logger.info("\(log)")
                                default:
                                    return
                            }
                        }
                    default:
                        return
                }
                /*
                var questionIndexValue = 0
                
                for page in pages {
                    let index = page.pageRef?.pageNumber ?? 0
                    let rawText = page.string!
                    if index == 1  { // First Page
                        self.pages.append(CambridgePaperPage(index: index, questionIndices: [], rawText: rawText))
                    } else {
                        let questionIndices = page.getMCQQuestionIndices(
                            currentIndex: &questionIndexValue,
                            currentLetterIndex: &partIndexValue,
                            currentNumeralIndex: &numeralIndexValue
                        )

                        Self.logger.debug("Current question index \(questionIndices[0].index).")
                        Self.logger.debug("Current page number \(index).")
                        
                        self.pages.append(CambridgePaperPage(index: index, questionIndices: questionIndices, rawText: rawText))
                    }
                }
                 */
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


extension PDFPage {
    func getQuestionIndices(
        currentIndex: inout Int,
        currentLetterIndex: inout Int,
        currentNumeralIndex: inout Int
    ) -> [QuestionIndex] {
        guard let contents = attributedString else {
            return []
        }
        var partsDictionary = [Int: [Int]]()
        let boldStrings = contents
            .fetchBoldStrings()
            .reduce(" ", +)
        
        let regexNum = try! NSRegularExpression(pattern: "[0-9]+")
        let regexParts = try! NSRegularExpression(pattern: "\\([a-z]+\\)")
        var numbers = regexNum
            .returnMatches(boldStrings)
            .compactMap(Int.init)
        
        if let index = numbers.firstIndex(of: pageRef?.pageNumber ?? 0) {
            // Removes the page number from array of numbers
            numbers.remove(at: index)
        }
        
        let partsArray = regexParts
            .returnMatches(boldStrings)
            .map { $0.removingCharacters(in: CharacterSet(charactersIn: "()")) }
        
        if currentIndex >= 1 {
            // (i) (b) (a)
            for part in partsArray { // [a, b, i, ii, c, i, ii]
                switch part {
                    case PapersDatabase.letters[currentLetterIndex]:
                        partsDictionary[currentLetterIndex + 1] = []
                        currentLetterIndex += 1
                        currentNumeralIndex = 0
                    case PapersDatabase.numerals[currentNumeralIndex]:
                        if partsDictionary[currentLetterIndex].isNilOrEmpty {
                            partsDictionary[currentLetterIndex] = []
                        }
                        partsDictionary[currentLetterIndex]!.append(currentNumeralIndex + 1)
                        currentNumeralIndex += 1
                    case PapersDatabase.letters[0]:
                        if numbers.contains(currentIndex + 1) {
                            currentIndex += 1
                            currentLetterIndex = 0
                            currentNumeralIndex = 0
                        }
                        partsDictionary[currentLetterIndex + 1] = []
                        currentLetterIndex += 1
                        currentNumeralIndex = 0
                    default:
                        continue
                }
            }
        }
        
        let parts = partsDictionary
            .map { (key, value) in
                QuestionIndex(index: key, type: .letter, parts: value.map({ QuestionIndex($0, type: .numeral) }) )
            }
        if parts.isEmpty {
            if numbers.contains(currentIndex + 1) {
                currentIndex += 1
                currentLetterIndex = 0
                currentNumeralIndex = 0
            }
            partsDictionary[currentLetterIndex + 1] = []
            currentLetterIndex += 1
            currentNumeralIndex = 0
        }
        
        return [QuestionIndex(index: currentIndex, type: .number, parts: parts)]
    }
    
    func getAnswers(for range: ClosedRange<Int>) -> [QuestionIndex : MultipleChoiceAnswer] {
        guard let rawText = self.string else {
            return [:]
        }
        let regex = try! NSRegularExpression(pattern: "[0-4]*[0-9]\\s?[A-D]")
        let matches = regex.returnMatches(rawText).map({ $0.removing(allOf: " ")})
        var final: [QuestionIndex : MultipleChoiceAnswer] = [:]
        var i: Int = range.lowerBound
        
        
        for m in matches {
            if m.last != nil {
                if m.removing(at: m.lastIndex) == "\(i)"  {
                    final[QuestionIndex(i)] = MultipleChoiceAnswer(index: QuestionIndex(i), value: MultipleChoiceValue(rawValue: String(m.last!))!)
                    i += 1
                }
            }
        }
        
        return final
    }
}
