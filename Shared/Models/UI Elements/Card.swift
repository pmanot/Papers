//
// Copyright (c) Purav Manot
//

import Foundation

struct Card: Identifiable, Hashable {
    let id = UUID()
    let prompt: String
    let answer: String
}

extension Card {
    static var example: Card = Card(prompt: "What are photons?", answer: "Discreet packets of energy")
    static var exampleDeck: [Card] = [Card(prompt: "What are photons?", answer: "Discreet packets of energy"), Card(prompt: "Define force", answer: "The rate of change of momentum"), Card(prompt: "Define velocity", answer: "The rate of change of displacement"), Card(prompt: "0 Celsius (C) in Kelvin (K)", answer: "273 Kelvin (K)")]
}
