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
    init(paperFilename: PaperFilename) {
        let chunks = paperFilename.rawValue.split(separator: "_")
        switch chunks[1].dropLast(2) {
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
    
    func compact() -> String {
        switch self {
            case .febMarch:
                return "Feb-March"
            case .mayJune:
                return "May-June"
            case .octNov:
                return "Oct-Nov"
        }
    }
}
