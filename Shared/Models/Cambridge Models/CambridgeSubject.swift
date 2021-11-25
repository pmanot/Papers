//
// Copyright (c) Purav Manot
//

import Foundation

enum CambridgeSubject: String, Codable, Hashable {
    case chemistry = "Chemistry"
    case physics = "Physics"
    case maths = "Maths"
    case other = ""
}

extension CambridgeSubject {
    init(paperCode: String){
        switch paperCode.dropLast(10) {
            case "9701":
                self = .chemistry
            case "9702":
                self = .physics
            default:
                self = .other
        }
    }
}