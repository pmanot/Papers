//
// Copyright (c) Purav Manot
//

import PDFKit

struct Question: Identifiable, Hashable, Codable {
    var id = UUID()
    var index: QuestionIndex
    var chooseIndex: Bool = false
    var subQuestions: [SubQuestion] = []
    var pages: [QuestionPaperPage] = []
    var check: QuestionCheck
    init(index: Int = 1, pages: [QuestionPaperPage]){
        self.index = QuestionIndex(number: index)
        self.pages = pages
        self.check = .unsolved
    }
    
    mutating func checked(_ check: QuestionCheck){
        self.check = check
    }
    var searchTags: [String] {
        return ["\(index.number)"] + pages.map { $0.rawText } + (pages.first?.metadata.searchTags ?? [])
    }
}

enum QuestionCheck: Int, Codable {
    case unsolved = 0
    case correct = 1
    case incorrect = 2
}
