//
// Copyright (c) Purav Manot
//

import Foundation

struct Card: Identifiable, Hashable, Codable {
    var id: String {
        prompt + answer
    }
    var prompt: String
    var answer: String
    var keywords: [String] = []
}

extension Card {
    static var example: Card = Card(prompt: "What are photons?", answer: "Discreet packets of energy")
    static var empty: Card = Card(prompt: "", answer: "")
    static var exampleDeck: [Card] = [Card(prompt: "What are photons?", answer: "Discreet packets of energy"), Card(prompt: "Define force", answer: "The rate of change of momentum"), Card(prompt: "Define velocity", answer: "The rate of change of displacement"), Card(prompt: "0 Celsius (C) in Kelvin (K)", answer: "273 Kelvin (K)")]
    
    func generate() -> Card {
        Card(prompt: self.prompt, answer: self.answer)
    }
    
    func isEmpty() -> Bool {
        prompt == "" && answer == ""
    }
}


struct Stack: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var cards: [Card]
}

extension Stack {
    static var empty = Stack(title: "", cards: [])
    static var example = Stack(title: "Example", cards: [Card(prompt: "What are photons?", answer: "Discreet packets of energy"), Card(prompt: "Define force", answer: "The rate of change of momentum"), Card(prompt: "Define velocity", answer: "The rate of change of displacement"), Card(prompt: "0 Celsius (C) in Kelvin (K)", answer: "273 Kelvin (K)")])
}
