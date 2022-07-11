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
    @State var paperSelection: CambridgePaperType = .questionPaper
    @State var testMode = false
    var onSave: () -> () {
        {
            !applicationStore.papersDatabase.savedQuestions.contains(question) ? applicationStore.papersDatabase.savedQuestions.append(question) : applicationStore.papersDatabase.savedQuestions.remove { $0 == question }
        }
    }
    
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
            
            Toolbar(markschemeShowing: $markschemeShowing, answerOverlayShowing: .constant(false), paperSelection: $paperSelection, testMode: $testMode, datasheetShowing: $datasheetShowing, save: onSave, isSaved: applicationStore.papersDatabase.savedQuestions.contains(question))
                .zIndex(3)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

extension QuestionView {
    func calculatedMarkschemeIndex() -> Double {
        (paperSelection == .markScheme) ? 1 : 0
    }
    
    func calculatedQuestionPaperIndex() -> Double {
        (paperSelection == .questionPaper) ? 1 : 0
    }
    
    func calculatedDatasheetIndex() -> Double {
        (paperSelection == .datasheet) ? 2 : 0
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



