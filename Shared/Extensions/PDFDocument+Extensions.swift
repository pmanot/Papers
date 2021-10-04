//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

extension PDFDocument {
    func extractText(pages: [Int]) -> String {
        var extractedText = ""
        for page in pages {
            extractedText.append(self.page(at: page)!.string! + " ")
        }
        return extractedText
    }
}
