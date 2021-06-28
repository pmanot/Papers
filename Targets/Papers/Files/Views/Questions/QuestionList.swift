//
// Copyright (c) Purav Manot
//

import PDFKit
import SwiftUI

struct QuestionList: View {
    @State var paper: Paper = Paper.example
    
    init(_ paper: Paper) {
        self.paper = paper
    }
    
    var body: some View {
        List(paper.questions) { question in
            Row(question)
        }
        .navigationTitle("Questions")
    }
}

struct QuestionList_Previews: PreviewProvider {
    static var previews: some View {
        QuestionList(Paper.example)
    }
}


extension QuestionList{
    struct Row: View {
        var question: Question
        
        init(_ question: Question) {
            self.question = question
        }
        
        var body: some View {
            NavigationLink(destination: QuestionView(question)) {
                HStack {
                    Group {
                        Text(String(question.index))
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(.heavy)
                            .frame(width: 20)
                            .padding()
                        Text("\(question.pages.count) page" + (question.pages.count > 1 ? "s" : ""))
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(width: 60, alignment: .leading)
                    }
                }
            }
        }
    }
}
