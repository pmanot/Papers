//
// Copyright (c) Purav Manot
//

import Foundation

extension Array where Element == QuestionPaper {
    func questions() -> [Question] {
        self.map { $0.questions }.reduce([], +)
    }
}
