//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

extension Array where Element == CambridgePaperMetadata {
    func matching(_ url: URL) -> CambridgePaperMetadata? {
        self.first(where: { $0.paperFilename == url.getPaperFilename() })
    }
}

extension PaperFilename {
    func derivePaperCode() -> PaperCode {
        var result: String = ""
        
        let chunks = rawValue.split(separator: "_")
        
        result += "\(chunks[0])/"
        result += "\(chunks[3])/"
        
        switch chunks[1].dropLast(2) {
            case "s":
                result += "M/J/"
            case "w":
                result += "O/N/"
            case "m":
                result += "F/M/"
            default:
                result += "F/M/"
        }
        
        result += "\(chunks[1].dropFirst())"
        
        return PaperCode(rawValue: result)
    }
}
