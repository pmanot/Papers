//
// Copyright (c) Purav Manot
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    
    let question: Question
    let bundle: CambridgePaperBundle
    @State var markSchemeToggle: Bool = false
    
    init(_ question: Question, bundle: CambridgePaperBundle){
        self.question = question
        self.bundle = bundle
    }
    
    var body: some View {
        ZStack {
            WrappedPDFView(pdf: bundle.questionPaper!.pdf, pages: question.pages)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
            
            if bundle.markScheme != nil && markSchemeToggle {
                WrappedPDFView(pdf: bundle.markScheme!.pdf)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
            }
            
            Toolbar(markSchemeToggle: $markSchemeToggle)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(Question.example, bundle: CambridgePaperBundle(questionPaper: nil, markScheme: nil))
            .environmentObject(ApplicationStore())
    }
}




