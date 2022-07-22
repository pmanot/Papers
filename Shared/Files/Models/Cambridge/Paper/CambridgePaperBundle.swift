//
// Copyright (c) Purav Manot
//

import Foundation
import Swift
import PDFKit

/// A bundle of the question paper and the mark scheme.
struct CambridgePaperBundle: Identifiable, Hashable {
    var id: PaperCode
    let questionPaper: CambridgePaper?
    let markScheme: CambridgePaper?
    
    var datasheetBySubject: PDFDocument? {
        PapersDatabase.datasheetBySubject[self.metadata.subject]
    }
    
    var metadata: CambridgePaperMetadata {
        questionPaper?.metadata ?? markScheme!.metadata
    }
    
    init(
        questionPaper: CambridgePaper?,
        markScheme: CambridgePaper?
    ) {
        self.id = questionPaper?.metadata.paperCode ?? markScheme!.metadata.paperCode
        self.questionPaper = questionPaper
        self.markScheme = markScheme
    }
    
    func index(in bundles: [CambridgePaperBundle]) -> Int {
        return bundles.firstIndex(of: self)!
    }
}
