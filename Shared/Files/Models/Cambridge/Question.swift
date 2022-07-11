//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct Question: Codable, Hashable, Identifiable {
    var id: String {
        details.code + "_i\(index)"
    }
    let details: CambridgePaperDetails
    let index: QuestionIndex
    var check: QuestionCheck = .unsolved
    var pages: [CambridgePaperPage]
    var rawText: String {
        pages.map { $0.rawText }.reduce("", +)
    }
    
    init(index: QuestionIndex, pages: [CambridgePaperPage], metadata: CambridgePaperMetadata){
        self.index = index
        self.pages = pages
        self.details = CambridgePaperDetails(paperCode: metadata.code)
    }
    
    func getContents(pdf: PDFDocument) -> AttributedString {
        pages.compactMap { AttributedString(pdf.page(at: $0.index - 1)!.attributedString!) }.reduce(AttributedString(), +)
    }
}

// Question Index that holds data about nested indices inside a question
struct QuestionIndex: Identifiable, Hashable, Codable {
    var id: String {
        "\(self.index), \(self.type), \(self.parts.count)"
    }
    
    let index: Int
    let type: QuestionIndexType
    var parts: [QuestionIndex]
    
    init(_ index: Int, type: QuestionIndexType = .number) {
        self.index = index
        self.type = type
        self.parts = []
    }
    
    init(index: Int, type: QuestionIndexType, parts: [QuestionIndex]){
        self.index = index
        self.type = type
        self.parts = parts
    }
    
    init(_ indices: [QuestionIndex]){
        self.index = indices.first?.index ?? 1
        self.type = indices.first?.type ?? .number
        self.parts = combine(indices.map { $0.parts }.reduce([], +))
    }
    
    func displayedIndex() -> String {
        switch type {
            case .number, .subNumber:
                return "\(self.index)"
            case .letter:
                return PapersDatabase.letters[self.index - 1]
            case .numeral:
                return PapersDatabase.numerals[self.index - 1]
        }
    }
}

enum QuestionIndexType: Hashable, Codable {
    case number, letter, numeral, subNumber
}

enum QuestionCheck: Int, Codable {
    case unsolved = 0
    case correct = 1
    case incorrect = 2
}

func combine(_ indexArray: [QuestionIndex]) -> [QuestionIndex] {
    var final: [QuestionIndex] = []
    for index in (indexArray) {
        if final.map({ $0.index }).contains(index.index) {
            let i = final.firstIndex(where: {$0.index == index.index })!
            let a = final[i].parts
            let b = index.parts
            final.remove(at: i)
            final.append(QuestionIndex(index: index.index, type: index.type, parts: combine(a + b)))
        } else {
            final.append(index)
        }
    }
    ///
    return final.sorted(by: { $0.index <= $1.index })
}
