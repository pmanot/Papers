//
// Copyright (c) Purav Manot
//

import Foundation
import Swift

/// A bundle of the question paper and the mark scheme.
struct CambridgePaperBundle: Hashable {
    var questionPaper: CambridgeQuestionPaper?
    var markScheme: CambridgeMarkscheme?

    var metadata: CambridgePaperMetadata {
        questionPaper?.metadata ?? markScheme!.metadata
    }

    var questionPaperCode: String {
        markScheme?.metadata.questionPaperCode ?? questionPaper!.metadata.questionPaperCode
    }

    init(questionPaper: CambridgeQuestionPaper?, markScheme: CambridgeMarkscheme?) {
        self.questionPaper = questionPaper
        self.markScheme = markScheme
    }
}
