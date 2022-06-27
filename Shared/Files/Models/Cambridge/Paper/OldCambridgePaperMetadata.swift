//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

extension Array where Element == CambridgePaperMetadata {
    func matching(_ url: URL) -> CambridgePaperMetadata? {
        self.first { $0.code == url.getPaperCode() }
    }
}

func getQuestionPaperCode(_ paperCode: String) -> String {
    var extendedPaperCode: String = ""
    let paperCodeChunks = paperCode.split(separator: "_")
    extendedPaperCode += "\(paperCodeChunks[0])/"
    extendedPaperCode += "\(paperCodeChunks[3])/"
    switch paperCodeChunks[1].dropLast(2) {
    case "s":
        extendedPaperCode += "M/J/"
    case "w":
        extendedPaperCode += "O/N/"
    case "m":
        extendedPaperCode += "F/M/"
    default:
        extendedPaperCode += "F/M/"
    }
    extendedPaperCode += "\(paperCodeChunks[1].dropFirst())"
    
    return extendedPaperCode
}
