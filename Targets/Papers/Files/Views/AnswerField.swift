//
// Copyright (c) Purav Manot
//

import SwiftUI

struct AnswerField: View {
    @State private var answers: [Answer] = [Answer(paper: Paper.example)]
    var question: Question
    @State var index: QuestionIndex = QuestionIndex()
    
    init(_ question: Question){
        UITextView.appearance().backgroundColor = .clear
        self.question = question
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .frame(width: answers.count > 1 ? 20*CGFloat((answers.count)) : 0, height: 18.5)
                .padding()
                .foregroundColor(.black)
            TabView {
                ForEach(answers, id: \.id) { answer in
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom) {
                            IndexPicker(index: $answers[answers.firstIndex(of: answer)!].index, question: question)
                            
                            ButtonSymbol("plus.square.fill"){
                                withAnimation {
                                    answers.append(Answer(paper: Paper.example, index: QuestionIndex(letter: QuestionIndex.letters[QuestionIndex.letters.firstIndex(of: answers.last!.index.letter!)! + 1])))
                                }
                            }
                            .font(.title)
                            .frame(width: 26, height: 26)
                            .foregroundColor(.green)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(antialiased: true)
                            )
                        }
                        .padding(.vertical, 5)
                        
                        TextEditor(text: $answers[answers.firstIndex(of: answer)!].text)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 6)
                            .font(.body)
                            .background(Color.primary.clipShape(RoundedRectangle(cornerRadius: 12)).colorInvert())
                            .opacity(0.8)
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(antialiased: true).foregroundColor(.primary))
                            .padding([.bottom, .horizontal, .top], 5)
                    }
                }
                .animation(.easeIn)
            }
            .tabViewStyle(PageTabViewStyle())
        }
        .animation(.spring())
    }
}

struct AnswerField_Previews: PreviewProvider {
    static var previews: some View {
        AnswerField(Paper.example.questions[0])
    }
}

extension AnswerField {
    struct IndexPicker: View {
        @Namespace private var animation
        @Binding var index: QuestionIndex
        let question: Question
        
        var body: some View {
            HStack(alignment: .bottom) {
                Text(String(question.index))
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(antialiased: true)
                            .frame(width: 45, height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(antialiased: true)
                                    .frame(width: 50, height: 50)
                            )
                    )
                    .frame(width: 50, height: 50)
                    .padding(.leading, 5)
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
                                .background(Color.secondary.clipShape(RoundedRectangle(cornerRadius: 10)).opacity(0.8))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(antialiased: true)
                )
                .matchedGeometryEffect(id: "chooseIndex", in: animation)
            }
        }
    }
}
