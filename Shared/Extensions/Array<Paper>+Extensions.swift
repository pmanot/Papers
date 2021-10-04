//
// Copyright (c) Purav Manot
//

import Foundation

extension Array where Element == CambridgeQuestionPaper {
    func questions() -> [Question] {
        self.map { $0.questions }.reduce([], +)
    }
}
