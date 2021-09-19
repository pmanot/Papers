//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct QuestionPaperPage: Hashable, Codable {
    let pageNumber: Int
    let metadata: CambridgeMetadata
    let type: CambridgePageType
    let rawText: String
}

struct MarkSchemePage: Hashable, Codable {
    let pageNumber: Int
    let metadata: CambridgeMetadata
}
