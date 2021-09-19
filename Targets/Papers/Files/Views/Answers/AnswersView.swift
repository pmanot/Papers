//
//  AnswersView.swift
//  Papers
//
//  Created by Purav Manot on 04/07/21.
//

import SwiftUI

struct AnswersView: View {
    @State var paper: QuestionPaper
    var fetchedAnswers: [QuestionIndex : String]
    
    @Binding var answersShowing: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if paper.markscheme != nil {
                PDFPageView(markScheme: paper.markscheme!)
            }
            TabView {
                ForEach(Array(fetchedAnswers.keys), id: \.self) { key in
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
                        .padding(10)
                        .background(Color.primary.colorInvert().cornerRadius(10).shadow(radius: 3).padding(2))
                        
                        VStack {
                            ButtonSymbol("checkmark"){
                                endEditing()
                            }
                            .foregroundColor(.green)
                            .padding(15)
                            .background(Color.primary.colorInvert().cornerRadius(10).shadow(radius: 3))
                            
                            ButtonSymbol("xmark"){
                            }
                            .foregroundColor(.red)
                            .padding(15)
                            .background(Color.primary.colorInvert().cornerRadius(10).shadow(radius: 3))
                        }
                        .font(.title2)
                        .padding(2)
                    }
                }
                
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 250)
            .padding(.horizontal, 5)
            
        }
    }
}

struct AnswersView_Previews: PreviewProvider {
    static var previews: some View {
        AnswersView(paper: QuestionPaper.example, fetchedAnswers: [QuestionIndex.example: "This is an example Answer! let me try writieneifniewnifnewinviewnvinweivniwenviewjhicjewidhiewnciewhfiewmihiwwiefiwejigjiwheifmewig"], answersShowing: .constant(true))
    }
}
