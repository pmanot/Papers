//
// Copyright (c) Purav Manot
//

import Foundation

struct CambridgeMetaData: Hashable, Codable {
    let paperCode: String
    
    var subject: Subject {
        switch paperCode.dropLast(10) {
            case "9701":
                return .chemistry
            case "9702":
                return .physics
            default:
                return .other
        }
    }
    
    var variant: PaperVariant {
        if paperCode.contains("_s"){
            return .mayJune
        } else if paperCode.contains("_w") {
            return .octNov
        } else {
            return .febMarch
        }
    }
    
    var year: Int {
        Int(String(paperCode.dropFirst(6)).dropLast(6))!
    }
    
    var type: Int {
        Int(paperCode.dropFirst(12))!
    }
}
