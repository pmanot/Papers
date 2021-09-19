//
// Copyright (c) Purav Manot
//

import PDFKit
import Filesystem
import SwiftUI

struct QuestionPaper: Hashable, Codable {
    static let maximumNumberOfQuestionsPerPaper = 10
    
    let metadata: CambridgeMetadata
    let data: Data
    var markscheme: MarkScheme? {
        let markschemeCode = metadata.paperCode.id.replacingOccurrences(of: "qp", with: "ms")
        if Bundle.main.path(forResource: markschemeCode, ofType: "pdf") != nil {
            return MarkScheme(markschemeCode)
        } else {
            return nil
        }
    }
    var questions: [Question] = []
    
    init(_ paperCode: String) {
        metadata = CambridgeMetadata(paperCode: paperCode)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: paperCode, ofType: "pdf")!)
        data = PDFDocument(url: url)!.dataRepresentation()!
        print("calculated")
        
        fetchPages()
    }
    
    init(_ url: URL){
        data = PDFDocument(url: url)!.dataRepresentation()!
        metadata = CambridgeMetadata(paperCode: Paper(url: url).filename)
        fetchPages()
    }
    
    var pages: [QuestionPaperPage] = []
    
    mutating func fetchPages() {
        var questionNumber: Int = 1
        var lastIndex: Int = 0
        var firstPageIgnoringDatasheet: Int {
            switch metadata.subject {
                case .physics:
                    return 3
                case .chemistry:
                    return 0
                default:
                    return 3
            }
        }
        let regex = try! NSRegularExpression(pattern: "\\([a-h]*\\)")
        var letters: [String] = []
        let pdf = PDFDocument(data: data)!
        
        for pageNumber in 0..<pdf.pageCount {
            let page = pdf.page(at: pageNumber)!
            let rawPageText = page.string ?? ""
            if pageNumber < firstPageIgnoringDatasheet {
                pages.append(QuestionPaperPage(pageNumber: pageNumber, metadata: metadata, type: .datasheet, rawText: rawPageText))
            } else {
                if page.string!.contains("BLANK PAGE") {
                    pages.append(QuestionPaperPage(pageNumber: pageNumber, metadata: metadata, type: .blank, rawText: rawPageText))
                } else {
                    let pageImage = page.snapshot().cgImage!
                    let extractedText = recogniseText(from: pageImage.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 150, height: 1000)))!)
                    
                    letters.append(extractedText)
                    
                    if extractedText.contains(substring: "\(questionNumber)"){
                        let index = QuestionIndex(number: questionNumber, letter: nil, numeral: nil)
                        pages.append(QuestionPaperPage(pageNumber: pageNumber, metadata: metadata, type: .question(i: index), rawText: rawPageText))
                        lastIndex = questionNumber
                        questionNumber += 1
                    } else {
                        let index = QuestionIndex(number: lastIndex, letter: nil, numeral: nil)
                        pages.append(QuestionPaperPage(pageNumber: pageNumber, metadata: metadata, type: .questionContinuation(i: index), rawText: rawPageText))
                    }
                }
            }
        }
        
        for i in 1..<Self.maximumNumberOfQuestionsPerPaper {
            let index = QuestionIndex(number: i, letter: nil, numeral: nil)
            let pagesContainingQuestion = pages
                .filter { $0.type == .question(i: index) || $0.type == .questionContinuation(i: index)}
            if pagesContainingQuestion.count != 0 {
                var subQuestions: [SubQuestion] = []
                for page in pagesContainingQuestion {
                    subQuestions += (regex.returnMatches(pdf.page(at: page.pageNumber)!.string!).map { SubQuestion(QuestionIndex(letter: $0)) })
                }
                var question = Question(index: i, pages: pagesContainingQuestion)
                question.subQuestions = subQuestions
                questions.append(question)
            }
            print(metadata.paperCode.id + "\(questions.count)")
        }
    }
    
    func pdf() -> PDFDocument {
        PDFDocument(data: data)!
    }
}

extension QuestionPaper {
    static let example = QuestionPaper("9702_s19_qp_21")
    static let example2 = QuestionPaper("9702_s18_qp_21")
    static let exampleMs = MarkScheme("9702_s19_ms_21")
}


struct CodableQuestionPaper: Codable, Equatable {
    let metadata: CambridgeMetadata
    var pages: [QuestionPaperPage]
    
    init(_ questionPaper: QuestionPaper){
        pages = questionPaper.pages
        metadata = questionPaper.metadata
    }
}


extension Array where Element == QuestionPaper {
    func codableQuestionPaper() -> [CodableQuestionPaper]{
        return self.map { CodableQuestionPaper($0) }
    }
}
