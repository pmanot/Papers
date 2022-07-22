//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgePaperNumber: Int, Codable, Hashable {
    case paper1 = 1
    case paper2 = 2
    case paper3 = 3
    case paper4 = 4
    case paper5 = 5
    case paper6 = 6
}

extension CambridgePaperNumber {
    init(paperFilename: PaperFilename) {
        let chunks = paperFilename.rawValue.split(separator: "_")
        
        self.init(rawValue: Int(chunks[3].dropLast()) ?? 1)!
    }
}
