//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI
import PDFKit

struct CambridgePaperPage: Hashable, Codable {
    var questionIndices: [QuestionIndex] = []
    var contents: AttributedString
}
