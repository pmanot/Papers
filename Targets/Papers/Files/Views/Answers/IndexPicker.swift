//
// Copyright (c) Purav Manot
//

import SwiftUI

struct IndexPicker: View {
    @Namespace private var animation
    @Binding var index: QuestionIndex
    @Binding var currentAnswer: Int
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 7) {
            Button(action: {
                index.incrementNumber()
                currentAnswer = index.number
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
                NumeralPicker(index: $index)
                    .matchedGeometryEffect(id: "chooseNumeral", in: animation)
            }
        }
    }
}


struct LetterPicker: View {
    @Binding var index: QuestionIndex
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
    
    init(index: Binding<QuestionIndex>){
        self._index = index
        impactFeedbackgenerator.prepare()
    }
    
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
                    impactFeedbackgenerator.impactOccurred()
                    index.letter = "a"
                }
                .buttonStyle(PlainButtonStyle())
                .font(.title, weight: .light)
                .frame(width: 25, height: 25)
            } else {
                Button(action: {
                    impactFeedbackgenerator.impactOccurred()
                    withAnimation {index.incrementLetter()}
                }){
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
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
    
    init(index: Binding<QuestionIndex>){
        self._index = index
        impactFeedbackgenerator.prepare()
    }
    
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
                    impactFeedbackgenerator.impactOccurred()
                    index.numeral = "i"
                }
                .buttonStyle(PlainButtonStyle())
                .font(.title, weight: .light)
                .frame(width: 25, height: 25)
            } else {
                Button(action: {
                    impactFeedbackgenerator.impactOccurred()
                    withAnimation {index.incrementNumeral()}
                }){
                    Text(index.numeral ?? "")
                        .modifier(IndexNumeral())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
