//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgePaperVariant: Int, Codable, Hashable {
    case variant1 = 1
    case variant2 = 2
    case variant3 = 3
}

extension CambridgePaperVariant {
    init(paperCode: String){
        let paperCodeChunks = paperCode.split(separator: "_")
        self.init(rawValue: Int(paperCodeChunks[3].dropFirst()) ?? 1)!
    }
}
