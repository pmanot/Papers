//
// Copyright (c) Purav Manot
//

import Foundation
import Swift
import PDFKit

/// A bundle of the question paper and the mark scheme.
struct CambridgePaperBundle: Hashable {
    let questionPaper: CambridgeQuestionPaper?
    let markScheme: CambridgeMarkscheme?
    
    var datasheetBySubject: PDFDocument? {
        PapersDatabase.datasheetBySubject[self.metadata.subject]
    }

    var metadata: OldCambridgePaperMetadata {
        questionPaper?.metadata ?? markScheme!.metadata
    }

    var questionPaperCode: String {
        questionPaper?.metadata.questionPaperCode ?? markScheme!.metadata.questionPaperCode
    }

    init(questionPaper: CambridgeQuestionPaper?, markScheme: CambridgeMarkscheme?) {
        self.questionPaper = questionPaper
        self.markScheme = markScheme
    }
}
