//
// Copyright (c) Purav Manot
//

import Foundation

extension Array where Element == CambridgeQuestionPaper {
    func questions() -> [Question] {
        self.map { $0.questions }.reduce([], +)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension Array where Element == URL {
    func getQuestionPaperURLs() -> [URL] {
        return self.filter { $0.getPaperCode().isQuestionPaper() }
    }
    
    func getMarkschemeURLs() -> [URL] {
        return self.filter { $0.getPaperCode().isMarkscheme() }
    }
}
