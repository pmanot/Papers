//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct CambridgeQuestionPaper: Hashable {
    let pdf: PDFDocument
    let metadata: CambridgePaperMetadata
    let pages: [CambridgePaperPage]
    var questions: [Question] = []
    
    init(url: URL, metadata: CambridgePaperMetadata){
        pdf = PDFDocument(url: url)!
        if metadata.paperCode == url.getPaperCode() {
            self.metadata = metadata
        } else {
            self.metadata = CambridgePaperMetadata(paperCode: url.deletingPathExtension().lastPathComponent)
        }
        pages = metadata.pageData
        fetchQuestionsFromPages()
    }
    
    mutating func fetchQuestionsFromPages(){
        var question: Question
        for i in 1..<15 {
            question = Question(pdf: pdf, index: QuestionIndex(i), pages: pages.filter { $0.type == .questionPaperPage(index: QuestionIndex(i)) })
            if question.pages != [] {
                questions.append(question)
                print(question.index.number)
            } else {
                break
            }
        }
    }
    
}
