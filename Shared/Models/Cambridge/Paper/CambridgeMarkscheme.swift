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
    let metadata: OldCambridgePaperMetadata
    let pages: [OldCambridgePaperPage]
    
    init(url: URL, metadata: OldCambridgePaperMetadata){
        self.url = url
        if metadata.paperCode == url.getPaperCode() {
            self.metadata = metadata
        } else {
            self.metadata = OldCambridgePaperMetadata(paperCode: url.deletingPathExtension().lastPathComponent)
        }
        pages = metadata.pageData
    }
}
