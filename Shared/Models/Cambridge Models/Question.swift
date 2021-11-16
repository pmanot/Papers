//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct Question: Hashable, Identifiable {
    let id = UUID()
    let metadata: CambridgePaperMetadata

    let pdf: PDFDocument
    let index: QuestionIndex
    var check: QuestionCheck = .unsolved
    var subQuestions: [QuestionIndex] = []
    var pages: [CambridgePaperPage]
    let rawText: String
    
    init(pdf: PDFDocument, index: QuestionIndex, pages: [CambridgePaperPage], metadata: CambridgePaperMetadata){
        self.pdf = pdf
        self.index = index
        self.pages = pages
        self.rawText = pages.map { $0.rawText }.reduce("", +)
        self.metadata = metadata
    }
}

extension Question {
    static var example = Question(pdf: PDFDocument(url: PapersDatabase.urls[0])!, index: QuestionIndex(1), pages: [CambridgePaperPage(type: .questionPaperPage(index: QuestionIndex(1)), rawText: "", pageNumber: 4), CambridgePaperPage(type: .questionPaperPage(index: QuestionIndex(1)), rawText: "", pageNumber: 5)], metadata: CambridgePaperMetadata(url: PapersDatabase.urls[0]))
}

enum QuestionCheck: Int, Codable {
    case unsolved = 0
    case correct = 1
    case incorrect = 2
}

struct QuestionIndex: Hashable, Codable {
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
}


enum MCQSelection: String, Codable, Hashable {
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
}
