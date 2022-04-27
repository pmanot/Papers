//
// Copyright (c) Purav Manot
//

import FoundationX
import PDFKit
import Swallow
import SwiftUIX

struct CambridgePaperPage: Hashable, Codable {
    var index: Int
    var questionIndices: [QuestionIndex] = []
    var rawText: String
    
    func getPage(pdf: PDFDocument) -> PDFPage {
        pdf.page(at: index - 1)!
    }
}
