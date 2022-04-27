//
// Copyright (c) Purav Manot
//

import Foundation

extension String {
    func wordCount() -> Int {
        var count: Int = 0
        var space: Bool = true
        for char in self.appending(" ") {
            if char == " " && space == false {
                count += 1
                space = true
            } else if char != " " {
                space = false
            }
        }
        return count
    }
}

extension String {
    func isMarkscheme() -> Bool {
        self.split(separator: "_")[2] == "ms"
    }
    
    func isQuestionPaper() -> Bool {
        self.split(separator: "_")[2] == "qp"
    }
}

extension String {
    func formattedQuestionText() -> String {
        self.removing(contentsOf: (0..<10).map { String($0) }.reduce("", +))
    }
}

