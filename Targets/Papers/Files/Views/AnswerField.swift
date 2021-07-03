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
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 7) {
                Button(action: {
                    index.increment()
                }){
                    Text(String(index.number))
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .frame(width: 38, height: 38)
                        .modifier(RoundedBorder())
                        .padding(3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(lineWidth: 2, antialiased: true)
                        )
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
                    ButtonSymbol("xmark.square.fill", onToggle: "xmark.square"){
                        index.letter = "a"
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.title, weight: .light)
                    .frame(width: 25, height: 25)
                } else {
                    Button(action: {withAnimation {index.letter = ""}}){
                        Text(index.letter ?? "")
                            .foregroundColor(.primary)
                            .bold()
                            .frame(width: 30, height: 30)
                            .colorInvert()
                            .background(Color.primary.clipShape(RoundedRectangle(cornerRadius: 10)))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .modifier(RoundedBorder())
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
                    ButtonSymbol("xmark.square.fill", onToggle: "xmark.square"){
                        index.numeral = "i"
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.title, weight: .light)
                    .frame(width: 25, height: 25)
                } else {
                    Button(action: {withAnimation {index.numeral = ""}}){
                        Text(index.numeral ?? "")
                            .foregroundColor(.primary)
                            .bold()
                            .frame(width: 23, height: 23)
                            .colorInvert()
                            .background(Color.primary.clipShape(RoundedRectangle(cornerRadius: 8)))
                            .padding(2)
                            .modifier(RoundedBorder())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .modifier(RoundedBorder())
                }
            }
        }
    }
}
