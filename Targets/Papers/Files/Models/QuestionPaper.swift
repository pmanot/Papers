//
// Copyright (c) Purav Manot
//

import PDFKit
import Filesystem
import SwiftUI

struct QuestionPaper: Hashable {
    let metadata: CambridgeMetaData
    let pdf: PDFDocument
    var markscheme: MarkScheme? {
        let markschemeCode = metadata.paperCode.replacingOccurrences(of: "qp", with: "ms")
        if Bundle.main.path(forResource: markschemeCode, ofType: "pdf") != nil {
            return MarkScheme(markschemeCode)
        } else {
            return nil
        }
    }
    var questions: [Question] = []
    
    init(_ paperCode: String) {
        metadata = CambridgeMetaData(paperCode: paperCode)
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: paperCode, ofType: "pdf")!)
        pdf = PDFDocument(url: url)!
        
        
        extractQuestions(questionPages)
        print("calculated")
    }
    
    init(_ codablePaper: CodableQuestionPaper){
        metadata = codablePaper.metaData
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: metadata.paperCode, ofType: "pdf")!)
        pdf = PDFDocument(url: url)!
        
        extractQuestions(codablePaper.questionPages)
        print("loaded from codable")
        
    }
    
    mutating func extractQuestions(_ questionPages: [Int: [Int]]) {
        for index in questionPages.keys {
            if questionPages[index] != [] {
                questions.append(Question(paper: self, page: questionPages[index]!, index: index))
                questions.sort(by: {$0.index.number < $1.index.number})
            }
        }
    }
    
    var questionPages: [Int: [Int]] {
        var questionPages: [Int: [Int]] = [:]
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
        for pageNumber in firstPageIgnoringDatasheet..<pdf.pageCount {
            if !pdf.page(at: pageNumber)!.string!.contains("BLANK PAGE") {
                
                let page = pdf.page(at: pageNumber)!.snapshot().cgImage!.cropping(to: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 150, height: 1000)))!
                let extractedText = recogniseText(from: page)
                
                print(extractedText)
                
                if extractedText.contains(substring: "\(questionNumber)"){
                    print(extractedText)
                    
                    questionPages[questionNumber] = [pageNumber]
                    lastIndex = questionNumber
                    questionNumber += 1
                } else {
                    if questionPages[lastIndex] != nil {
                        questionPages[lastIndex]!.append(pageNumber)
                        print(pageNumber)
                        
                    }
                }
                
            }
        }
        return questionPages
    }
}

extension QuestionPaper {
    static let example = QuestionPaper("9702_s19_qp_21")
    static let example2 = QuestionPaper("9702_s18_qp_21")
    static let exampleMs = MarkScheme("9702_s19_ms_21")
}

struct CodableQuestionPaper: Codable, Equatable {
    let metaData: CambridgeMetaData
    var questionPages: [Int:[Int]] = [:]
    
    init(_ questionPaper: QuestionPaper){
        metaData = questionPaper.metadata
        questionPages = questionPaper.questionPages
    }
}

extension Array where Element == CodableQuestionPaper {
    func questionPaper() -> [QuestionPaper]{
        return self.map { QuestionPaper($0) }
    }
}

extension Array where Element == QuestionPaper {
    func codableQuestionPaper() -> [CodableQuestionPaper]{
        return self.map { CodableQuestionPaper($0) }
    }
}
