//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgePaperType: Codable, Hashable {
    case markScheme
    case questionPaper
    case datasheet
    case examinerReport
    case other
}

extension CambridgePaperType {
    init() {
        self = .other
    }
    
    init(paperFilename: PaperFilename) {
        let chunks = paperFilename.rawValue.split(separator: "_")
        
        switch chunks[2] {
            case "qp":
                self = .questionPaper
            case "ms":
                self = .markScheme
            default:
                self = .datasheet
        }
    }
}
