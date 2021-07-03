//
// Copyright (c) Purav Manot
//

import Foundation

struct QuestionIndex: Identifiable, Hashable {
    let id = UUID()
    var number: Int = 1
    var letter: String? = nil
    var numeral: String? = nil
    var subNumber: Int? = nil
    
    mutating func increment(){
        if numeral != nil && numeral != "" {
            if numeral != QuestionIndex.romanNumerals.last {
                numeral = QuestionIndex.romanNumerals[QuestionIndex.romanNumerals.firstIndex(of: numeral!)! + 1]
            }
        } else if letter != nil && letter != "" {
            if letter != QuestionIndex.letters.last {
                letter = QuestionIndex.letters[QuestionIndex.romanNumerals.firstIndex(of: letter!)! + 1]
            }
        } else {
            number += 1
            if number > 10 {
                number = 1
            }
        }
    }
    
    func nextQuestionIndex() -> Self {
        var nextIndex = self
        nextIndex.increment()
        return nextIndex
    }
}

extension QuestionIndex {
    static var romanNumerals: [String] = ["i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x"]
    static var letters: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"]
}

/*
enum RomanNumerals: String {
    typealias RawValue = String
    case none = ""
    case i = "i"
    case ii = "ii"
    case iii = "iii"
    case iv = "iv"
    case v = "v"
    case vi = "vi"
    case vii = "vii"
    case viii = "viii"
    case ix = "ix"
    case x = "x"
}
*/
