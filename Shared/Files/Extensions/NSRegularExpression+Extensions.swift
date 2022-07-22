//
// Copyright (c) Purav Manot
//

import Foundation

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.length)
        return firstMatch(in: string, options: [], range: range) != nil
    }
    
    func returnMatches(_ string: String) -> [String] {
        if matches(string) {
            let range = NSRange(location: 0, length: string.length)
            return matches(in: string, options: [], range: range).compactMap {
                String(string[Range($0.range, in: string)!])
            }
        } else {
            return []
        }
    }
}
