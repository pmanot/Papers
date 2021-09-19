//
// Copyright (c) Purav Manot
//

import Foundation

enum CambridgePageType: Hashable {
    case blank
    case datasheet
    case question(i: QuestionIndex)
    case answer(i: QuestionIndex)
    case questionContinuation(i: QuestionIndex)
}

extension CambridgePageType: Codable {
    enum CodingKeys: CodingKey {
        case rawValue
        case associatedValue
    }
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                let rawValue = try container.decode(Int.self, forKey: .rawValue)
                switch rawValue {
                case 0:
                    self = .blank
                case 1:
                    self = .datasheet
                case 2:
                    let i = try container.decode(QuestionIndex.self, forKey: .associatedValue)
                    self = .question(i: i)
                case 3:
                    let i = try container.decode(QuestionIndex.self, forKey: .associatedValue)
                    self = .answer(i: i)
                case 4:
                    let i = try container.decode(QuestionIndex.self, forKey: .associatedValue)
                    self = .questionContinuation(i: i)
                default:
                    throw CodingError.unknownValue
                }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .blank:
            try container.encode(0, forKey: .rawValue)
        case .datasheet:
            try container.encode(1, forKey: .rawValue)
        case .question(let i):
            try container.encode(2, forKey: .rawValue)
            try container.encode(i, forKey: .associatedValue)
        case .answer(let i):
            try container.encode(3, forKey: .rawValue)
            try container.encode(i, forKey: .associatedValue)
        case .questionContinuation(let i):
            try container.encode(4, forKey: .rawValue)
            try container.encode(i, forKey: .associatedValue)
        }
    }
    
}
