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

enum CambridgePaperCodeType: Int, Codable {
    case markscheme = 0
    case questionPaper = 1
    case datasheet = 2
    case other = 3
}
