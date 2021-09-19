//
// Copyright (c) Purav Manot
//

import SwiftUI

struct AnswerField: View {
    @Binding var answers: [Answer]
    
    @State var index: QuestionIndex = QuestionIndex()
    @State var currentAnswer: Int = 1
    @State var charCount: Int = 0
    
    let paper: QuestionPaper
    let question: Question
    let directory = DocumentDirectory()
    
    init(_ paper: QuestionPaper, _ question: Question, _ answers: Binding<[Answer]>){
        UITextView.appearance().backgroundColor = .clear
        self.question = question
        self._answers = answers
        self.paper = paper
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
                                        
                                        ZStack(alignment: .bottomTrailing) {
                                            TextEditor(text: $answers[answers.firstIndex(of: answer)!].text)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .onChange(of: answers[answers.firstIndex(of: answer)!].text, perform: { value in
                                                    DispatchQueue.global().async(qos: .userInteractive) {
                                                        charCount = value.wordCount()
                                                    }
                                                })
                                            Text("\(charCount)")
                                                .font(.caption)
                                                .fontWeight(.heavy)
                                                .foregroundColor(.yellow)
                                                .frame(width: 20, height: 30)
                                        }
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 5)
                                        .font(.subheadline)
                                        .background(Color.primary.clipShape(RoundedRectangle(cornerRadius: 12)).colorInvert())
                                        .opacity(0.9)
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
                                    answers.append(Answer(paper: paper, question: question, index: question.index))
                                }
                            } else {
                                let copy = answers[currentAnswerIndex!]
                                answers.remove(at: currentAnswerIndex!)
                                answers.append(copy)
                            }
                        }
                    }
                }
                .onAppear {
                    currentAnswer = question.index.number
                    print("changed")
                    print(question.subQuestions)
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
                    .hidden(!question.chooseIndex)

                    ButtonSymbol("plus.square.fill"){
                        withAnimation {
                            switch question.chooseIndex {
                            case true:
                                withAnimation {
                                    answers.append(Answer(paper: paper, question: question, index: answers.last?.index.getNextQuestionIndex() ?? QuestionIndex()))
                                }
                            case false:
                                var nextIndex = answers.last?.index
                                nextIndex?.incrementLetter()
                                withAnimation {
                                    answers.append(Answer(paper: paper, question: question, index: nextIndex ?? QuestionIndex()))
                                }
                            }
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
        AnswerField(QuestionPaper.example, Question(index: 1, pages: []), .constant([ Answer(paper: QuestionPaper.example, question: Question(index: 1, pages: []) ) ] ) )
    }
}


