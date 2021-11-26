//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct CambridgeMultipleChoiceMarkscheme: Hashable {
    let pdf: PDFDocument
    let metadata: CambridgePaperMetadata
    let pages: [CambridgePaperPage]
    var answers: [Answer] = []
    let rawText: String
    
    init(url: URL, metadata: CambridgePaperMetadata){
        pdf = PDFDocument(url: url)!
        if metadata.paperCode == url.getPaperCode() {
            self.metadata = metadata
        } else {
            self.metadata = CambridgePaperMetadata(paperCode: url.deletingPathExtension().lastPathComponent)
        }
        pages = metadata.pageData
        rawText = metadata.rawText
    }
    
}
