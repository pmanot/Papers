//
//  AnswersView.swift
//  Papers
//
//  Created by Purav Manot on 04/07/21.
//

import SwiftUI

struct AnswersView: View {
    let question: Question
    var fetchedAnswers: [QuestionIndex : String]
    
    @Binding var answersShowing: Bool
    
    var body: some View {
        VStack {
            PDFPageView(markScheme: question.paper.markscheme!)
                .modifier(RoundedBorder())
                .padding(.horizontal, 5)
                .frame(height: 350)
                .padding(.top, 5)
            TabView {
                ForEach(Array(fetchedAnswers.keys)) { key in
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(alignment: .bottom) {
                                Text(String(key.number))
                                    .modifier(IndexNumber())
                                Text(key.letter ?? "")
                                    .modifier(IndexLetter())
                                    .hidden(key.numeral == nil)
                                Text(key.numeral ?? "")
                                    .modifier(IndexNumeral())
                                    .hidden(key.numeral == nil)
                            }
                            Text(fetchedAnswers[key]!)
                                .multilineTextAlignment(.leading)
                                .font(.body)
                                .padding(.vertical, 5)
                        }
                        .padding(.trailing, 30)
                        
                        VStack {
                            ButtonSymbol("checkmark.circle.fill"){
                                
                            }
                            .foregroundColor(.green)
                            .padding(1)
                            .overlay(Circle().strokeBorder(antialiased: true))
                            
                            ButtonSymbol("xmark.circle.fill"){
                                
                            }
                            .foregroundColor(.red)
                            .padding(1)
                            .overlay(Circle().strokeBorder(antialiased: true))
                        }
                        .font(.title)
                    }
                }
                .padding()
                .padding(.horizontal, 20)
                .modifier(RoundedBorder())
            }
            .tabViewStyle(PageTabViewStyle())
            .padding(5)
            .padding(.bottom, 5)
            
            ToolBar(showAnswers: $answersShowing, answerFieldShowing: .constant(false))
                .padding()
        }
    }
}

struct AnswersView_Previews: PreviewProvider {
    static var previews: some View {
        AnswersView(question: QuestionPaper.example.questions[0], fetchedAnswers: [QuestionIndex.example: "This is an example Answer!"], answersShowing: .constant(true))
    }
}
