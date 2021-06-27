//
// Copyright (c) Purav Manot
//

import SwiftUI

struct QuestionView: View {
    var question: Question
    var pages: [Int]
    
    @State var answer: String = ""
    
    init(_ question: Question = Question(paper: Paper.example, page: [0, 1])){
        self.question = question
        self.pages = question.pages
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
            
            PdfView(question.paper, pages: question.pages)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
