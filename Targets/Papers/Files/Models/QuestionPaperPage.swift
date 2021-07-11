//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct QuestionPaperPage: Hashable, Codable {
    let pageNumber: Int
    let metadata: CambridgeMetaData
    let type: CambridgePageType
}
