//
// Copyright (c) Purav Manot
//

import PDFKit
import SwiftUIX

struct Question: Identifiable, Hashable {
    let id = UUID()
    let pages: [Int]
    let paper: Paper
    var index: Int
    
    init(paper: Paper, page: [Int], index: Int = 0){
        self.index = index
        self.pages = page
        self.paper = paper
    }
}
