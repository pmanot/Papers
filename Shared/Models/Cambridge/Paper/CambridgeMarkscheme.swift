//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct CambridgeMarkscheme: Hashable {
    var url: URL
    var pdf: PDFDocument {
        PDFDocument(url: url)!
    }
    let metadata: CambridgePaperMetadata
    let pages: [CambridgePaperPage]
    
    init(url: URL, metadata: CambridgePaperMetadata){
        self.url = url
        if metadata.paperCode == url.getPaperCode() {
            self.metadata = metadata
        } else {
            self.metadata = CambridgePaperMetadata(paperCode: url.deletingPathExtension().lastPathComponent)
        }
        pages = metadata.pageData
    }
}
