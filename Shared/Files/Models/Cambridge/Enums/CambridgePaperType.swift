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
    init(){
        self = .other
    }
    
    init(paperCode: String) {
        let paperCodeChunks = paperCode.split(separator: "_")
        switch paperCodeChunks[2] {
        case "qp":
                self = .questionPaper
        case "ms":
                self = .markScheme
        default:
            self = .datasheet
        }
    }
}
