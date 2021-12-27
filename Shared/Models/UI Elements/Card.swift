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
}
