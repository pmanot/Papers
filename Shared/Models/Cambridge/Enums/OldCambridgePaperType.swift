//
// Copyright (c) Purav Manot
//

import Foundation

public enum OldCambridgePaperType: String, Codable, Hashable {
    case markScheme = "Marking Scheme"
    case questionPaper = "Question Paper"
    case datasheet = "Data Sheet"
    case other = "Uncategorised"
}

extension OldCambridgePaperType {
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
