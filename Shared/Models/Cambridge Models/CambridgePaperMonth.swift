//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgePaperMonth: String, Codable, Hashable {
    case febMarch = "Febuary-March"
    case mayJune = "May-June"
    case octNov = "October-November"
    
}

extension CambridgePaperMonth {
    init(paperCode: String){
        let paperCodeChunks = paperCode.split(separator: "_")
        switch paperCodeChunks[1].dropLast(2) {
        case "s":
            self = .mayJune
        case "w":
            self = .octNov
        case "m":
            self = .febMarch
        default:
            self = .febMarch
        }
    }
}
