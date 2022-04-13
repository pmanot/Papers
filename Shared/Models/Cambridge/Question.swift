//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct Question: Hashable, Identifiable {
    let id = UUID()
    let metadata: CambridgePaperMetadata
    let index: QuestionIndex
    var check: QuestionCheck = .unsolved
    var pages: [CambridgePaperPage]
    let contents: AttributedString
    
    init(index: QuestionIndex, pages: [CambridgePaperPage], metadata: CambridgePaperMetadata){
        self.index = index
        self.pages = pages
        self.contents = pages.map { $0.contents }.reduce("", +)
        self.metadata = metadata
    }
}


enum QuestionCheck: Int, Codable {
    case unsolved = 0
    case correct = 1
    case incorrect = 2
}

