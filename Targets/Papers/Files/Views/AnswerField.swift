//
// Copyright (c) Purav Manot
//

import SwiftUI

struct AnswerField: View {
    @State private var text: String = ""
    @State private var answers: [Answer] = [Answer(paper: Paper.example)]
    @State private var letterChosen: Bool = false
    var question: Question
    @State var index: QuestionIndex = QuestionIndex()
    @Namespace private var animation
    
    init(_ question: Question){
        UITextView.appearance().backgroundColor = .clear
        self.question = question
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .foregroundColor(.primary)
                .padding(.top, 52)
                .padding(.horizontal, 6)
                .font(.body)
                .foregroundColor(.black)
                .background(Color.primary.clipShape(RoundedRectangle(cornerRadius: 12)).colorInvert())
                .opacity(0.8)
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(antialiased: true).foregroundColor(.primary))
            
            HStack {
                Text(String(question.index))
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(antialiased: true)
                            .frame(width: 50, height: 50)
                    )
                    .frame(width: 50, height: 50)
                    .padding([.leading, .vertical], 5)
                Group {
                    if index.letter == nil {
                        Picker("", selection: $index){
                            ForEach(QuestionIndex.letters, id: \.self){ letter in
                                Text(letter)
                                    .tag(QuestionIndex(number: question.index, letter: letter))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 260)
                    } else {
                        Button(action: {withAnimation {index.letter = nil}}){
                            Text(index.letter ?? "")
                                .bold()
                                .frame(width: 30, height: 30)
                                .background(Color.secondary.clipShape(RoundedRectangle(cornerRadius: 10)).opacity(0.5))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(antialiased: true)
                )
                .matchedGeometryEffect(id: "chooseIndex", in: animation)
                .padding(.vertical, 10)
            }
        }
        .animation(.spring())
        .padding()
    }
}

struct AnswerField_Previews: PreviewProvider {
    static var previews: some View {
        AnswerField(Paper.example.questions[0])
    }
}

