//
//  QuestionView.swift
//  Papers
//
//  Created by Purav Manot on 23/06/21.
//

import SwiftUI

struct QuestionView: View {
    var question: Question
    @State var answer: String = ""
    init(_ question: Question = Question(paperCode: "9702_s19_qp_21", index: 4)){
        self.question = question
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
            VStack {
                PdfView(question.url, pages: .index(question.index))
            }
            AnswerField()
                
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
