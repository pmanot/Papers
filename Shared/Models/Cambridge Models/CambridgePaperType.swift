//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgePaperType: String, Codable, Hashable {
    case markscheme = "Marking Scheme"
    case questionPaper = "Question Paper"
    case datasheet = "Data Sheet"
    case other = "Uncategorised"
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
            self = .markscheme
        default:
            self = .datasheet
        }
    }
}
