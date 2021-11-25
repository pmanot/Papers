//
// Copyright (c) Purav Manot
//

import Foundation

struct Answer: Codable, Hashable {
    let index: QuestionIndex
    var value: AnswerValue
    
    mutating func updateValue(value: AnswerValue){
        self.value = value
    }
    
    func selected(_ selection: MCQSelection) -> Bool {
        return self.value == .multipleChoice(choice: selection)
    }
    
    mutating func toggleChoice(_ choice: MCQSelection){
        switch self.value {
            case .multipleChoice(choice: choice):
                self.updateValue(value: AnswerValue.multipleChoice(choice: .none))
            default:
                self.updateValue(value: AnswerValue.multipleChoice(choice: choice))
        }
    }
}

enum AnswerValue: Codable, Hashable {
    case multipleChoice(choice: MCQSelection)
    case text(string: String)
    
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
                case "multipleChoice":
                    let choice = try container.decode(MCQSelection.self, forKey: .associatedValue)
                    self = .multipleChoice(choice: choice)
                case "text":
                    let string = try container.decode(String.self, forKey: .associatedValue)
                    self = .text(string: string)
                default:
                    throw CodingError.unknownValue
                }
    }
    
    func encode(to encoder: Encoder) throws { // conform to Encodable
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .multipleChoice(let choice):
            try container.encode("multipleChoice", forKey: .rawValue)
            try container.encode(choice, forKey: .associatedValue)
        case .text(let string):
            try container.encode("text", forKey: .rawValue)
            try container.encode(string, forKey: .associatedValue)
        }
    }
    
}

enum MCQSelection: String, Codable, Hashable {
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case none = "N"
}
