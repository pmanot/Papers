//
// Copyright (c) Purav Manot
//

import Foundation

func FuzzyMatch(search: String, in text: String) -> Bool {
    if search.length <= text.length {
        
    }
    
    return false
}


extension String {
    func fuzzyMatch(_ needle: String) -> [String.Index]? {
        if needle.isEmpty { return [] }
        var matchedIndices: [String.Index] = []
        var remainder = needle[...]
        
        for index in self.indices {
            let char = self[index]
            if char == remainder[remainder.startIndex] {
                matchedIndices.append(index)
                remainder.removeFirst()
                if remainder.isEmpty { return matchedIndices }
            }
        }
        
        return nil
    }
    
    func match(_ needle: String) -> Bool {
        if needle.removing(allOf: " ").isEmpty {
            return false
        }
        if self.localizedCaseInsensitiveContains(needle){
            return true
        }
        
        return false
    }
    
    func getTextAround(string: String) -> String {
        if let range = self.lowercased().range(of: string.lowercased()) {
            let expandedRange = Range(bounds: (lower: range.lowerBound, upper: index(range.lowerBound, offsetBy: 40) ))
            return String(self[expandedRange] + "...")
        }
        return ""
    }
}
