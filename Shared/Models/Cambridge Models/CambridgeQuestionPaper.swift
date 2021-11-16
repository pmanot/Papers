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
    let rawText: String
    
    init(url: URL, metadata: CambridgePaperMetadata){
        pdf = PDFDocument(url: url)!
        if metadata.paperCode == url.getPaperCode() {
            self.metadata = metadata
        } else {
            self.metadata = CambridgePaperMetadata(paperCode: url.deletingPathExtension().lastPathComponent)
        }
        pages = metadata.pageData
        rawText = metadata.rawText
        fetchQuestionsFromPages()
    }
    
    mutating func fetchQuestionsFromPages(){
        var question: Question
        for i in 1..<15 {
            question = Question(pdf: pdf, index: QuestionIndex(i), pages: pages.filter { $0.type == .questionPaperPage(index: QuestionIndex(i)) }, metadata: metadata)
            if question.pages != [] {
                questions.append(question)
                print(question.index.number)
            } else {
                break
            }
        }
    }
    
}


/* in progress...
 var i = 1
 var pageBuffer: [CambridgePaperPage] = []
 
 for page in pages {
     if page.type != .datasheet && page.type != .blank {
         if page.type == .questionPaperPage(index: QuestionIndex(i)){
             pageBuffer.append(page)
         } else if page.type == .questionPaperPage(index: QuestionIndex(i + 1)) {
             let question = Question(pdf: pdf, index: QuestionIndex(i), pages: pageBuffer, metadata: self.metadata)
             questions.append(question)
             
             pageBuffer = []
             
             if i == metadata.numberOfQuestions {
                 break
             }
             i += 1
         }
 */
