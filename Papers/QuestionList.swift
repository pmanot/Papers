//
//  QuestionList.swift
//  Papers
//
//  Created by Purav Manot on 24/06/21.
//

import SwiftUI
import PDFKit

struct QuestionList: View {
    @State var paper: Paper = examplePaper
    @State var text: String = ""
    init(_ paper: Paper){
        self.paper = paper
    }
    var body: some View {
        NavigationView {
            List(paper.questions) { question in
                NavigationLink(destination: QuestionView(question)) {
                    Text(String(question.index))
                }
            }
        }
        .onAppear {
            paper.extractQuestions()
        }
    }
}

struct QuestionList_Previews: PreviewProvider {
    static var previews: some View {
        QuestionList(examplePaper)
    }
}



