//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgePaperType: Codable, Hashable {
    case markScheme(details: CambridgePaperDetails)
    case questionPaper(details: CambridgePaperDetails)
    case datasheet
    case examinerReport
    case other
}

extension CambridgePaperType {
    init(){
        self = .other
    }
    
    init(paperCode: String) {
        let paperCodeChunks = paperCode.split(separator: "_")
        switch paperCodeChunks[2] {
        case "qp":
                self = .questionPaper(details: .init(paperCode: paperCode))
        case "ms":
                self = .markScheme(details: .init(paperCode: paperCode))
        default:
            self = .datasheet
        }
    }
    
    var details: CambridgePaperDetails? {
        switch self {
            case .markScheme(let details), .questionPaper(let details):
                return details
            default:
                return nil
        }
    }
}
