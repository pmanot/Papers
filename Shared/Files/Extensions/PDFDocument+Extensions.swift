//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

extension PDFDocument {
    /// Fetches the pages of this PDF document.
    func pages() -> [PDFPage] {
        (0..<self.pageCount).compactMap({ self.page(at: $0) })
    }
}
