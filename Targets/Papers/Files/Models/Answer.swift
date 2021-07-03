//
// Copyright (c) Purav Manot
//

import Foundation


struct Answer: Identifiable, Hashable {
    let id = UUID()
    var paper: Paper
    var index: QuestionIndex = QuestionIndex()
    var text: String = ""
}
