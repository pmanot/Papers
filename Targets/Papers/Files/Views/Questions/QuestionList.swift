//
// Copyright (c) Purav Manot
//

import PDFKit
import SwiftUI

struct QuestionList: View {
    var paper: QuestionPaper
    
    init(_ paper: QuestionPaper) {
        self.paper = paper
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: QuestionView(paper.questions[0])) {
                    VStack(alignment: .leading){
                        Text(paper.metadata.subject.rawValue)
                            .font(.title)
                            .fontWeight(.heavy)
                        Text(paper.metadata.month.rawValue + " " + String(paper.metadata.year))
                            .font(.callout)
                            .fontWeight(.light)
                    }
                    .padding(10)
                }
            }
            
            Section(header: Text("Questions").font(.title).fontWeight(.heavy)){
                ForEach(paper.questions, id: \.id) { question in
                    Row(question)
                        .listStyle(GroupedListStyle())
                }
            }
            .textCase(.none)
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct QuestionList_Previews: PreviewProvider {
    static var previews: some View {
        QuestionList(QuestionPaper.example)
    }
}


extension QuestionList{
    struct Row: View {
        let question: Question
        
        init(_ question: Question) {
            self.question = question
        }
        
        var body: some View {
            NavigationLink(destination: QuestionView(question)) {
                HStack {
                    Group {
                        Text(String(question.index.number))
                            .font(.title)
                            .fontWeight(.heavy)
                            .frame(width: 30)
                            .padding()
                        Text("\(question.pages.count) page" + (question.pages.count > 1 ? "s" : ""))
                            .font(.caption2)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 4)
                            .background(Capsule().strokeBorder().foregroundColor(.secondary))
                    }
                }
                .multilineTextAlignment(.leading)
            }
        }
    }
}
