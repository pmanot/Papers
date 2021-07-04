//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

struct Answer: Identifiable, Hashable {
    let id = UUID()
    var paper: QuestionPaper
    var index: QuestionIndex = QuestionIndex()
    var text: String = ""
}

struct CodableAnswers: Codable {
    var paperCode: String = ""
    var answers: [QuestionIndex: String] = [:]
    init(_ answers: [Answer]){
        if answers.count > 0 {
            paperCode = answers[0].paper.paperCode
        }
        for answer in answers {
            self.answers[answer.index] = answer.text
        }
    }
}
