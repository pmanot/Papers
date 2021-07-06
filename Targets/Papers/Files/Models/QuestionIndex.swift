//
// Copyright (c) Purav Manot
//

import Foundation

struct QuestionIndex: Identifiable, Hashable, Codable {
    var id = UUID()
    var number: Int = 1
    var letter: String? = "a"
    var numeral: String? = nil
    var subNumber: Int? = nil
    
    mutating func increment(){
        if numeral != nil && numeral != "" {
            incrementNumeral()
        } else if letter != nil && letter != "" {
            incrementLetter()
        } else {
            incrementNumber()
        }
    }
    
    mutating func incrementNumber(){
        if number > 10 {
            number = 1
        } else {
            number += 1
        }
    }
    
    mutating func incrementLetter(){
        if letter != QuestionIndex.letters.last {
            letter = QuestionIndex.letters[QuestionIndex.letters.firstIndex(of: letter!)! + 1]
        }
    }
    
    mutating func incrementNumeral(){
        if numeral != QuestionIndex.romanNumerals.last {
            numeral = QuestionIndex.romanNumerals[QuestionIndex.romanNumerals.firstIndex(of: numeral!)! + 1]
        }
    }
    
    func getNextQuestionIndex() -> Self {
        var nextIndex = QuestionIndex(number: number, letter: letter, numeral: numeral, subNumber: subNumber)
        nextIndex.increment()
        return nextIndex
    }
    
}

extension QuestionIndex {
    static var romanNumerals: [String] = ["i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x"]
    static var letters: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"]
    
    static var example = QuestionIndex(number: 2, letter: "a", numeral: "iv")
}
