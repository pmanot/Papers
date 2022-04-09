//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct CambridgeQuestionPaper: Hashable {
    var url: URL
    var pdf: PDFDocument {
        PDFDocument(url: url)!
    }
    
    let metadata: OldCambridgePaperMetadata
    let pages: [OldCambridgePaperPage]
    var questions: [Question] = []
    let rawText: String
    let solved: [SolvedPaper] = []
    
    init(url: URL, metadata: OldCambridgePaperMetadata){
        self.url = url
        if metadata.paperCode == url.getPaperCode() {
            self.metadata = metadata
        } else {
            self.metadata = OldCambridgePaperMetadata(paperCode: url.deletingPathExtension().lastPathComponent)
        }
        pages = metadata.pageData
        rawText = metadata.rawText
        fetchQuestionsFromPages()
    }
    
    mutating func fetchQuestionsFromPages(){
        if !(metadata.paperNumber == .paper1) {
            var question: Question
            for i in 1..<(metadata.numberOfQuestions + 1) {
                question = Question(index: OldQuestionIndex(i), pages: pages.filter { $0.type == .questionPaperPage(index: OldQuestionIndex(i)) }, metadata: metadata)
                if question.pages != [] {
                    questions.append(question)
                } else {
                    break
                }
            }
        }
    }
}
