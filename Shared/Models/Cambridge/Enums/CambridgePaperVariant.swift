//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgePaperVariant: Int, Codable, Hashable {
    case variant1 = 1
    case variant2 = 2
    case variant3 = 3
    case variant4 = 4
    case variant5 = 5
    case variant6 = 6
    case variant7 = 7
    case variant8 = 8
}

extension CambridgePaperVariant {
    init(paperCode: String){
        let paperCodeChunks = paperCode.split(separator: "_")
        self.init(rawValue: Int(paperCodeChunks[3].dropFirst()) ?? 1)!
    }
}
