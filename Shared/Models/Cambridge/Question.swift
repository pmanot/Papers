//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct Question: Hashable, Identifiable {
    let id = UUID()
    let metadata: CambridgePaperMetadata
    let index: OldQuestionIndex
    var check: QuestionCheck = .unsolved
    var subQuestions: [OldQuestionIndex] = []
    var pages: [OldCambridgePaperPage]
    let rawText: String
    
    init(index: OldQuestionIndex, pages: [OldCambridgePaperPage], metadata: CambridgePaperMetadata){
        self.index = index
        self.pages = pages
        self.rawText = pages.map { $0.rawText }.reduce("", +)
        self.metadata = metadata
    }
}


enum QuestionCheck: Int, Codable {
    case unsolved = 0
    case correct = 1
    case incorrect = 2
}

struct OldQuestionIndex: Hashable, Codable {
    var number: Int = 1
    var letter: String? = nil
    var numeral: String? = nil
    var subNumber: Int? = nil
    
    init(_ number: Int, _ letter: String? = nil, _ numeral: String? = nil, subNumber: Int? = nil){
        self.number = number
        self.letter = letter
        self.numeral = numeral
        self.subNumber = subNumber
    }
    
    mutating func increment(){
        self.number += 1
    }
}
