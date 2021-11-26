//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

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
    
    init(paperCode: String){
        if regexMatches(string: paperCode, pattern: CambridgePaperMetadata.paperCodePattern) { // check if papercode is valid
            self.paperCode = paperCode
            self.questionPaperCode = getQuestionPaperCode(paperCode)
            let paperCodeChunks = paperCode.split(separator: "_")
            
            self.paperType = CambridgePaperType(paperCode: paperCode)
            self.paperNumber = CambridgePaperNumber(paperCode: paperCode)
            self.paperVariant = CambridgePaperVariant(paperCode: paperCode)
            self.month = CambridgePaperMonth(paperCode: paperCode)
            self.subject = CambridgeSubject(paperCode: paperCode)
            self.year = Int(paperCodeChunks[1].dropFirst())!
        } else { // papercode is not valid
            self.paperCode = "uncategorised"
            self.questionPaperCode = "uncategorised"
            self.paperNumber = CambridgePaperNumber.paper1
            self.paperType = CambridgePaperType.other
            self.paperVariant = CambridgePaperVariant.variant1
            self.month = CambridgePaperMonth.febMarch
            self.year = 00
            self.subject = .other
            
        }
    }
    
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
            for i in 0..<pdf.pageCount {
                switch paperNumber {
                    case .paper1: // paper 1 (mcq)
                        let pageNumber = i + 1
                        let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                        let rawPageText = page.string ?? "" // extract text from the page
                        pageData.append(CambridgePaperPage(type: .markSchemePage, rawText: rawPageText, pageNumber: pageNumber))

                        
                    default: // paper 4
                        let pageNumber = i + 1
                        let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                        let rawPageText = page.string ?? "" // extract text from the page
                        pageData.append(CambridgePaperPage(type: .markSchemePage, rawText: rawPageText, pageNumber: pageNumber))
                }
            }
        case .questionPaper:
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
                        
                        for i in 0..<pdf.pageCount {
                            let pageNumber = i + 1
                            let page = pdf.page(at: i)! // get the corresponding PDFPage from the page number
                            let rawPageText = page.string ?? "" // extract text from the page
                            
                            if rawPageText.contains("BLANK PAGE") { // check for blank page
                                pageData.append(CambridgePaperPage(type: .blank, rawText: "", pageNumber: pageNumber))
                            } else {
                                let snapshot = page.snapshot().cgImage!
                                let croppedSnapshot = snapshot.cropping(to: CGRect(origin: CGPoint(x: 50, y: 0), size: CGSize(width: 100, height: 1000)))! // crop page snapshot to only include page number
                                
                                if recogniseText(from: croppedSnapshot).contains("\(nextQuestionNumber)"){ // check if the page containes a new question (the next question)
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
