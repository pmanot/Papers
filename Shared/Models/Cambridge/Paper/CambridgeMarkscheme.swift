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
    let pages: [OldCambridgePaperPage]
    
    init(url: URL, metadata: CambridgePaperMetadata){
        self.url = url
        if metadata.code == url.getPaperCode() {
            self.metadata = metadata
        } else {
            self.metadata = CambridgePaperMetadata(code: url.deletingPathExtension().lastPathComponent)
        }
        pages = metadata.pageData
    }
}
