//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct QuestionView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    
    let question: Question
    let bundle: CambridgePaperBundle
    
    @State var markschemeShowing: Bool = false
    @State var datasheetShowing: Bool = false
    @State var testMode = false
    
    init(_ question: Question, bundle: CambridgePaperBundle){
        self.question = question
        self.bundle = bundle
    }
    
    var body: some View {
        ZStack {
            Group {
                // Question
                WrappedPDFView(pdf: bundle.questionPaper!.pdf, pages: question.pages)
                    .zIndex(calculatedQuestionPaperIndex())
                
                // Marking scheme
                if !bundle.markScheme.isNil {
                    WrappedPDFView(pdf: bundle.markScheme!.pdf)
                        .zIndex(calculatedMarkschemeIndex())
                }
                
                // Data sheet
                if !bundle.datasheetBySubject.isNil {
                    WrappedPDFView(pdf: bundle.datasheetBySubject!)
                        .zIndex(calculatedDatasheetIndex())
                }
                
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            
            Toolbar(markschemeShowing: $markschemeShowing, answerOverlayShowing: .constant(false), testMode: $testMode, datasheetShowing: $datasheetShowing)
                .zIndex(3)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

extension QuestionView {
    func calculatedMarkschemeIndex() -> Double {
        (bundle.markScheme != nil && markschemeShowing) ? 1 : 0
    }
    
    func calculatedQuestionPaperIndex() -> Double {
        (bundle.questionPaper != nil && !markschemeShowing) ? 1 : 0
    }
    
    func calculatedDatasheetIndex() -> Double {
        (bundle.questionPaper != nil && datasheetShowing) ? 2 : 0
    }
}


/*
struct QuestionView_Previews: PreviewProvider {

    static var previews: some View {
        PreviewQuestionView()
            .environmentObject(ApplicationStore())
    }
}
*/



