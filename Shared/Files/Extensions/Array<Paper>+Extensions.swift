//
// Copyright (c) Purav Manot
//

import Foundation

extension Array where Element == CambridgePaper {
    func questions() -> [Question] {
        self.map { $0.questions }.reduce([], +)
    }
}

extension Array where Element == CambridgePaperBundle {
    func indexedQuestions() -> [(Int, Question)] {
        (0..<(self.count)).map { i in
            (self[i].questionPaper?.questions ?? []).map { question in
                (i, question)
            }
        }.reduce([], +)
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

extension Array {
    mutating func rotate() {
        self = self.rotated()
    }
    
    func rotated() -> Self {
        if self.isEmpty {
            return self
        }
        var rotatedArray = self
        rotatedArray.insert(rotatedArray.popLast()!)
        return rotatedArray
    }
}

extension Array where Element == URL {
    func paperFiltered() -> [URL] {
        var filteredURLs: [URL] = []
        for url in self {
            let codeChunks = url.getPaperFilename().rawValue.split(separator: "_")
            if codeChunks.count > 2 {
                if codeChunks[2] == "ms" || codeChunks[2] == "qp" {
                    filteredURLs.append(url)
                }
            }
        }
        
        return filteredURLs
    }
}
