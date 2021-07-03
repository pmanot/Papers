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
        ZStack(alignment: .bottomTrailing) {
            Capsule()
                .frame(width: answers.count > 1 ? 20*CGFloat((answers.count)) : 0, height: 18.5)
                .padding()
                .foregroundColor(.black)
            TabView {
                ForEach(answers, id: \.id) { answer in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .bottom) {
                            IndexPicker(index: $answers[answers.firstIndex(of: answer)!].index)
                        }
                        .padding(.vertical, 5)
                        
                        TextEditor(text: $answers[answers.firstIndex(of: answer)!].text)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 6)
                            .font(.body)
                            .background(Color.primary.clipShape(RoundedRectangle(cornerRadius: 12)).colorInvert())
                            .opacity(0.8)
                            .modifier(RoundedBorder())
                            .padding([.bottom, .horizontal], 5)
                    }
                }
                .animation(.easeIn)
            }
            .tabViewStyle(PageTabViewStyle())
            ButtonSymbol("plus.square.fill"){
                withAnimation {
                    if answers.last?.index.letter != nil {
                        answers.append(Answer(paper: question.paper, index: index.nextQuestionIndex()))
                    } else {
                        answers.append(Answer(paper: question.paper))
                    }
                }
            }
            .font(.title, weight: .light)
            .foregroundColor(.green)
            .padding(10)
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
