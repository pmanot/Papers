//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUIX

struct Answer: Identifiable, Hashable {
    let id = UUID()
    let pages: [Int]
    let markscheme: MarkScheme
    var index: Int
    
    init(markscheme: MarkScheme, page: [Int], index: Int = 0){
        self.index = index
        self.pages = page
        self.markscheme = markscheme
    }
}
