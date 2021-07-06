//
// Copyright (c) Purav Manot
//

import PDFKit

struct Question: Identifiable, Hashable {
    let id = UUID()
    let pages: [Int]
    let paper: QuestionPaper
    var answer: AnswerSheet?
    var index: QuestionIndex
    
    init(paper: QuestionPaper, page: [Int], index: Int = 1){
        self.index = QuestionIndex(number: index)
        self.pages = page
        self.paper = paper
        answer = nil
    }
}
