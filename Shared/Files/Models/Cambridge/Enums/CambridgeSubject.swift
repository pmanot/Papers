//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgeSubject: String, Codable, Hashable {
    case chemistry = "Chemistry"
    case physics = "Physics"
    case biology = "Biology"
    case maths = "Mathematics"
    case english = "English"
    case other = ""
}

extension CambridgeSubject {
    init(paperCode: String){
        switch paperCode.dropLast(10) {
            case "9700":
                self = .biology
            case "9701":
                self = .chemistry
            case "9702":
                self = .physics
            case "9709":
                self = .maths
            case "9093":
                self = .english
            default:
                self = .other
        }
    }
}
