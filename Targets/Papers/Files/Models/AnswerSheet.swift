//
// Copyright (c) Purav Manot
//

import Foundation

struct AnswerSheet: Identifiable, Hashable {
    let id = UUID()
    let pages: [Int]
    let markscheme: MarkScheme
    var index: Int
    
    init(markscheme: MarkScheme = MarkScheme.example, page: [Int], index: Int = 0){
        self.index = index
        self.pages = page
        self.markscheme = markscheme
    }
}
