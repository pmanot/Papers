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

func regexMatches(string: String, pattern: String) -> Bool {
    let regex = try! NSRegularExpression(pattern: pattern)
    return regex.matches(string)
}

func regexReturnMatches(string: String, pattern: String) -> [String] {
    let regex = try! NSRegularExpression(pattern: pattern)
    return regex.returnMatches(string)
}
