//
//  IndexPicker.swift
//  Papers
//
//  Created by Purav Manot on 06/07/21.
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
