//
// Copyright (c) Purav Manot
//

import Foundation
import Swift
import PDFKit

/// A bundle of the question paper and the mark scheme.
struct CambridgePaperBundle: Identifiable, Hashable {
    let id = UUID()
    let questionPaper: CambridgePaper?
    let markScheme: CambridgePaper?
    
    var datasheetBySubject: PDFDocument? {
        PapersDatabase.datasheetBySubject[self.metadata.subject]
    }

    var metadata: CambridgePaperMetadata {
        questionPaper?.metadata ?? markScheme!.metadata
    }

    var questionPaperCode: String {
        questionPaper?.metadata.questionPaperCode ?? markScheme!.metadata.questionPaperCode
    }

    init(questionPaper: CambridgePaper?, markScheme: CambridgePaper?) {
        self.questionPaper = questionPaper
        self.markScheme = markScheme
    }
}
