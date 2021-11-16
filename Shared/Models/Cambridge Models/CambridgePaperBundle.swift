//
// Copyright (c) Purav Manot
//


import Foundation

struct CambridgePaperBundle: Hashable {
    var questionPaperCode: String
    
    var questionPaper: CambridgeQuestionPaper?
    var markscheme: CambridgeMarkscheme?
    var metadata: CambridgePaperMetadata
    
    init(questionPaper: CambridgeQuestionPaper?, markscheme: CambridgeMarkscheme?){
        self.questionPaper = questionPaper
        self.markscheme = markscheme
        questionPaperCode = markscheme?.metadata.questionPaperCode ?? questionPaper?.metadata.questionPaperCode ?? ""
        switch questionPaper {
            case nil:
                self.metadata = markscheme!.metadata
            default:
                self.metadata = questionPaper!.metadata
        }
    }
    
}
