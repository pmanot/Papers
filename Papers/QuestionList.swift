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
    @State var tapped: Bool = false
    init(_ paper: Paper){
        self.paper = paper
    }
    var body: some View {
            List(paper.questions) { question in
                NavigationLink(destination: QuestionView(question), isActive: $tapped) {
                    Text(String(question.index))
                }
            }
    }
}

struct QuestionList_Previews: PreviewProvider {
    static var previews: some View {
        QuestionList(examplePaper)
    }
}



