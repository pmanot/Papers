//
// Copyright (c) Purav Manot
//

import Foundation

struct Answer: Codable, Hashable {
    var time: TimeInterval? = nil
    let index: QuestionIndex
    var value: AnswerValue
    
    
    mutating func updateValue(value: AnswerValue){
        self.value = value
    }
    
    func selected(_ selection: MCQSelection) -> Bool {
        return self.value == .multipleChoice(choice: selection)
    }
    
    mutating func toggleChoice(_ choice: MCQSelection, timed: TimeInterval? = nil){
        switch self.value {
            case .multipleChoice(choice: choice):
                self.updateValue(value: AnswerValue.multipleChoice(choice: .none))
            default:
                self.updateValue(value: AnswerValue.multipleChoice(choice: choice))
        }
        if self.time == nil {
            self.time = timed
        } else {
            self.time! += timed!
        }
        
    }
}

typealias Answers = [QuestionIndex : AnswerValue]

enum AnswerValue: Codable, Hashable {
    case multipleChoice(choice: MCQSelection)
    case text(string: String)
    
    mutating func updateValue(value: AnswerValue){
        self = value
    }
    
    func selected(_ selection: MCQSelection) -> Bool {
        return self == .multipleChoice(choice: selection)
    }
    
    mutating func toggleChoice(_ choice: MCQSelection){
        switch self {
            case .multipleChoice(choice: choice):
                self.updateValue(value: AnswerValue.multipleChoice(choice: .none))
            default:
                self.updateValue(value: AnswerValue.multipleChoice(choice: choice))
        }
    }
    
}


extension AnswerValue {
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

extension Array where Element == Answer {
    static var exampleAnswers: [Answer] = (1...40).map {Answer(index: QuestionIndex($0), value: .multipleChoice(choice: .A))}
    static var exampleCorrectAnswers: [Answer] = (1...10).map {Answer(index: QuestionIndex($0), value: .multipleChoice(choice: .A))} + (11...35).map {Answer(index: QuestionIndex($0), value: .multipleChoice(choice: .C))} + (36...40).map {Answer(index: QuestionIndex($0), value: .multipleChoice(choice: .B))}
}
