//
// Copyright (c) Purav Manot
//

import SwiftUI

struct QuestionView: View {
    
    let question: Question
    @State var markschemeToggle: Bool = false
    
    init(_ question: Question){
        self.question = question
    }
    
    var body: some View {
        ZStack {
            WrappedPDFView(pdf: question.pdf, pages: question.pages)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
            Toolbar(markschemeToggle: $markschemeToggle)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(Question.example)
    }
}




