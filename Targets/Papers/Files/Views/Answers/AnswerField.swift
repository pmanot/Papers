//
// Copyright (c) Purav Manot
//

import SwiftUI

struct AnswerField: View {
    @EnvironmentObject var codableAnswers: Answers
    @Binding var answers: [Answer]
    
    @State var index: QuestionIndex = QuestionIndex()
    
    let question: Question
    let directory = DocumentDirectory()
    
    init(_ question: Question, _ answers: Binding<[Answer]>){
        UITextView.appearance().backgroundColor = .clear
        self.question = question
        self._answers = answers
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            /*
            Capsule()
                .frame(width: answers.count > 1 ? 20*CGFloat((answers.count)) : 0, height: 18.5)
                .padding()
                .foregroundColor(.black)
            */
            TabView {
                ForEach(answers, id: \.id) { answer in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .bottom) {
                            IndexPicker(index: $answers[answers.firstIndex(of: answer)!].index)
                                .padding(.trailing, 5)
                        }
                        .padding(.vertical, 5)
                        
                        TextEditor(text: $answers[answers.firstIndex(of: answer)!].text)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 5)
                            .font(.subheadline)
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
                    answers.append(Answer(paper: question.paper, index: answers.last?.index.getNextQuestionIndex() ?? QuestionIndex()))
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
        AnswerField(QuestionPaper.example.questions[0], .constant([Answer(paper: QuestionPaper.example)]))
    }
}

extension AnswerField {
    
    struct IndexPicker: View {
        @Namespace private var animation
        @Binding var index: QuestionIndex
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 7) {
                Button(action: {
                    index.increment()
                }){
                    Text(String(index.number))
                        .modifier(IndexNumber())
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 40, height: 40)
                .padding(.leading, 7)
                
                HStack(alignment: .bottom, spacing: 5) {
                    LetterPicker(index: $index)
                        .matchedGeometryEffect(id: "chooseLetter", in: animation)
                    if index.letter != "" && index.letter != nil {
                        NumeralPicker(index: $index)
                            .matchedGeometryEffect(id: "chooseNumeral", in: animation)
                    }
                }
            }
        }
    }
}

extension AnswerField.IndexPicker {
    struct LetterPicker: View {
        @Binding var index: QuestionIndex
        var body: some View {
            Group {
                if index.letter == "" {
                    VStack {
                        HStack(alignment: .center, spacing: 5) {
                            Picker("", selection: $index){
                                ForEach(QuestionIndex.letters, id: \.self){ letter in
                                    Text(letter)
                                        .tag(QuestionIndex(number: index.number, letter: letter, numeral: index.numeral))
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 260)
                            .modifier(RoundedBorder())
                            
                            ButtonSymbol("xmark.square", onToggle: "xmark.square.fill"){
                                index.letter = nil
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.title, weight: .light)
                            .frame(width: 25, height: 25)
                        }
                    }
                } else if index.letter == nil {
                    ButtonSymbol("square.dashed", onToggle: "square.dashed.inset.fill"){
                        index.letter = "a"
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.title, weight: .light)
                    .frame(width: 25, height: 25)
                } else {
                    Button(action: {withAnimation {index.letter = ""}}){
                        Text(index.letter ?? "")
                            .modifier(IndexLetter())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    struct NumeralPicker: View {
        @Binding var index: QuestionIndex
        var body: some View {
            Group {
                if index.numeral == "" {
                    HStack(alignment: .center, spacing: 5) {
                        Picker("", selection: $index){
                            ForEach(QuestionIndex.romanNumerals, id: \.self){ numeral in
                                Text(numeral)
                                    .tag(QuestionIndex(number: index.number, letter: index.letter, numeral: numeral))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 260)
                        .modifier(RoundedBorder())
                        
                        ButtonSymbol("xmark.square", onToggle: "xmark.square.fill"){
                            index.numeral = nil
                        }
                        .buttonStyle(PlainButtonStyle())
                        .font(.title, weight: .light)
                        .frame(width: 25, height: 25)
                    }
                } else if index.numeral == nil {
                    ButtonSymbol("square.dashed", onToggle: "square.dashed.inset.fill"){
                        index.numeral = "i"
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.title, weight: .light)
                    .frame(width: 25, height: 25)
                } else {
                    Button(action: {withAnimation {index.numeral = ""}}){
                        Text(index.numeral ?? "")
                            .modifier(IndexNumeral())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
