//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct CambridgePaper {
    var url: URL
    var pdf: PDFDocument {
        PDFDocument(url: url)!
    }
    var metadata: CambridgePaperMetadata
}

