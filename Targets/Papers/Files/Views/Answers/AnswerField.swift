//
// Copyright (c) Purav Manot
//

import SwiftUI

struct AnswerField: View {
    @Binding var answers: [Answer]
    
    @State var index: QuestionIndex = QuestionIndex()
    @State var currentAnswer: Int = 1
    
    let question: Question
    let directory = DocumentDirectory()
    
    init(_ question: Question, _ answers: Binding<[Answer]>){
        UITextView.appearance().backgroundColor = .clear
        self.question = question
        self._answers = answers
    }
    
    var body: some View {
        GeometryReader { display in
            VStack(alignment: .trailing) {
                /*
                Capsule()
                    .frame(width: answers.count > 1 ? 20*CGFloat((answers.count)) : 0, height: 18.5)
                    .padding()
                    .foregroundColor(.black)
                */
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(answers, id: \.id) { answer in
                            if answer.index.number == currentAnswer {
                                HStack {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(alignment: .bottom) {
                                            IndexPicker(index: $answers[answers.firstIndex(of: answer)!].index, currentAnswer: $currentAnswer)
                                                .padding(.trailing, 5)
                                        }
                                        .padding(.vertical, 5)
                                        
                                        TextEditor(text: $answers[answers.firstIndex(of: answer)!].text)
                                            .foregroundColor(.primary)
                                            .padding(.horizontal, 5)
                                            .font(.subheadline)
                                            .background(Color.primary.clipShape(RoundedRectangle(cornerRadius: 12)).colorInvert())
                                            .opacity(0.9)
                                            .modifier(RoundedBorder())
                                            .padding([.bottom, .horizontal], 5)
                                    }
                                }
                                .frame(width: display.size.width)
                            }
                        }
                        .animation(.easeIn)
                        .onChange(of: currentAnswer){ _ in
                            let currentAnswerIndex = answers.firstIndex(where: { $0.index.number == currentAnswer })
                            if currentAnswerIndex == nil {
                                withAnimation {
                                    answers.append(Answer(paper: question.paper, index: QuestionIndex(number: currentAnswer)))
                                }
                            } else {
                                let copy = answers[currentAnswerIndex!]
                                answers.remove(at: currentAnswerIndex!)
                                answers.append(copy)
                            }
                        }
                    }
                }
                
                HStack {
                    Picker("", selection: $currentAnswer){
                        ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], id: \.self){ number in
                            Text(String(number)).tag(number)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .modifier(RoundedBorder())
                    .frame(width: 310)

                    ButtonSymbol("plus.square.fill"){
                        withAnimation {
                            answers.append(Answer(paper: question.paper, index: answers.last?.index.getNextQuestionIndex() ?? QuestionIndex()))
                        }
                    }
                    .font(.title, weight: .light)
                    .foregroundColor(.green)
                }
                .animation(.spring())
                .padding([.horizontal, .bottom], 10)
                
            }
            .frame(height: display.size.height)
        }
    }
}

struct AnswerField_Previews: PreviewProvider {
    static var previews: some View {
        AnswerField(QuestionPaper.example.questions[0], .constant([Answer(paper: QuestionPaper.example)]))
    }
}


