//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct CambridgePaperPage: Codable, Hashable {
    let type: CambridgePageType
    let rawText: String
    let pageNumber: Int
    
    func getPage(pdf: PDFDocument) -> PDFPage {
        pdf.page(at: pageNumber - 1)!
    }
}

enum CambridgePageType: Codable, Hashable {
    case blank
    case datasheet
    case markSchemePage
    case multipleChoicePage(indexes: [QuestionIndex])
    case questionPaperPage(index: QuestionIndex)
    
    enum CodingKeys: CodingKey {
        case rawValue
        case associatedValue
    }
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws { // conform to Decodable
        let container = try decoder.container(keyedBy: CodingKeys.self)
                let rawValue = try container.decode(String.self, forKey: .rawValue)
                switch rawValue {
                case "blank":
                    self = .blank
                case "datasheet":
                    self = .datasheet
                case "markScheme":
                    self = .markSchemePage
                case "question":
                    let index = try container.decode(QuestionIndex.self, forKey: .associatedValue)
                    self = .questionPaperPage(index: index)
                case "multipleChoiceQuestions":
                    let indexes = try container.decode([QuestionIndex].self, forKey: .associatedValue)
                    self = .multipleChoicePage(indexes: indexes)
                default:
                    throw CodingError.unknownValue
                }
    }
    
    func encode(to encoder: Encoder) throws { // conform to Encodable
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .blank:
            try container.encode("blank", forKey: .rawValue)
        case .datasheet:
            try container.encode("datasheet", forKey: .rawValue)
        case .markSchemePage:
            try container.encode("markScheme", forKey: .rawValue)
        case .questionPaperPage(let index):
            try container.encode("question", forKey: .rawValue)
            try container.encode(index, forKey: .associatedValue)
        case .multipleChoicePage(let indexes):
            try container.encode("multipleChoiceQuestions", forKey: .rawValue)
            try container.encode(indexes, forKey: .associatedValue)
        }
    }
}
