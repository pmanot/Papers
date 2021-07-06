//
// Copyright (c) Purav Manot
//

import Foundation

extension NSRegularExpression {
    func matches(_ string: String, length: Int = 50) -> Bool {
        let range = NSRange(location: 0, length: length)
        return firstMatch(in: string, options: [], range: range) != nil
    }
    
    func returnMatches(_ string: String, _ length: Int = 50) -> [Int] {
        if matches(string) {
            let range = NSRange(location: 0, length: length)
            return matches(in: string, options: [], range: range).compactMap {
                Int(String(string[Range($0.range, in: string)!]))
            }
        } else {
            return []
        }
    }
}
