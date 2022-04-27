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
    func bundledQuestions() -> [(CambridgePaperBundle, Question)] {
        self.compactMap { bundle in bundle.questionPaper!.questions.map { question in (bundle, question)} }.reduce([], +)
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
            let codeChunks = url.getPaperCode().split(separator: "_")
            if codeChunks.count > 2 {
                if codeChunks[2] == "ms" || codeChunks[2] == "qp" {
                    filteredURLs.append(url)
                }
            }
        }
        
        return filteredURLs
    }
}
