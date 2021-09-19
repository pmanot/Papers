//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct MarkScheme: Identifiable, Hashable {
    let id = UUID()
    let metadata: CambridgeMetadata
    let url: URL
    let pdf: PDFDocument
    var answers: [AnswerSheet] = []
    
    init(_ msCode: String) {
        self.metadata = CambridgeMetadata(paperCode: msCode)
        url = URL(fileURLWithPath: Bundle.main.path(forResource: metadata.paperCode.id, ofType: "pdf")!)
        pdf = PDFDocument(url: url)!
        
        extractAnswers()
    }
    
    mutating func extractAnswers() {
        var answerPages: [Int: [Int]] = [:]
        var answerNumber: Int = 1
        
        for pageNumber in 3..<pdf.pageCount {
            answerPages[answerNumber] = [pageNumber]
            answerNumber += 1
        }
        
        for index in answerPages.keys {
            if answerPages[index] != [] {
                answers.append(AnswerSheet(markscheme: self, page: answerPages[index]!, index: index))
                answers.sort(by: {$0.index < $1.index})
            }
        }
    }
}

extension MarkScheme {
    static let example = MarkScheme("9702_s19_ms_21")
}
