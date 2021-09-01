//
// Copyright (c) Purav Manot
//

import Foundation

struct CambridgeMetadata: Hashable, Codable {
    init(paperCode: String){
        self.paperCode = CambridgePaperCode(paperCode)
    }
    
    let paperCode: CambridgePaperCode
    
    var subject: Subject {
        switch paperCode.id.dropLast(10) {
            case "9701":
                return .chemistry
            case "9702":
                return .physics
            default:
                return .other
        }
    }
    
    var month: CambridgePaperMonth {
        if paperCode.id.contains("_s"){
            return .mayJune
        } else if paperCode.id.contains("_w") {
            return .octNov
        } else {
            return .febMarch
        }
    }
    
    var year: Int {
        Int(String(paperCode.id.dropFirst(6)).dropLast(6))!
    }
    
    var type: Int {
        Int(paperCode.id.dropFirst(12))!
    }
}

struct CambridgePaperCode: Hashable, Codable {
    let id: String
    let type: CambridgePaperCodeType
    
    init(_ id: String){
        self.id = id
        if id.contains("_ms"){
            type = .markscheme
        } else if id.contains("_qp"){
            type = .questionPaper
        } else {
            type = .datasheet
        }
    }
}

enum CambridgePaperType: Hashable {
    case markscheme(number: CambridgePaperNumber, variant: CambridgePaperVariant)
    case questionPaper(number: CambridgePaperNumber, variant: CambridgePaperVariant)
    case datasheet
    case other
}

extension CambridgePaperType {
    private struct PaperTypeIdentifier: Codable {
        let number: CambridgePaperNumber
        let variant: CambridgePaperVariant
    }
}

extension CambridgePaperType: Codable {
    
    private enum CodingKeys: CodingKey {
        case base, typeIdentifier
    }
    
    private enum Base: String, Codable {
        case questionPaper, markscheme, datasheet, other
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .datasheet:
            try container.encode(Base.datasheet, forKey: .base)
        case .other:
            try container.encode(Base.other, forKey: .base)
        case .questionPaper(let number, let variant):
            try container.encode(Base.questionPaper, forKey: .base)
            try container.encode(PaperTypeIdentifier(number: number, variant: variant), forKey: .typeIdentifier)
        case .markscheme(let number, let variant):
            try container.encode(Base.markscheme, forKey: .base)
            try container.encode(PaperTypeIdentifier(number: number, variant: variant), forKey: .typeIdentifier)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        
        switch base {
        case .datasheet:
            self = .datasheet
        case .other:
            self = .other
        case .questionPaper:
            let typeIdentifier = try container.decode(PaperTypeIdentifier.self, forKey: .typeIdentifier)
            self = .questionPaper(number: typeIdentifier.number, variant: typeIdentifier.variant)
        case .markscheme:
            let typeIdentifier = try container.decode(PaperTypeIdentifier.self, forKey: .typeIdentifier)
            self = .markscheme(number: typeIdentifier.number, variant: typeIdentifier.variant)
        }
    }
    
}
