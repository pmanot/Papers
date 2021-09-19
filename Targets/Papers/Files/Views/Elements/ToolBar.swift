//
//  ToolBar.swift
//  Papers
//
//  Created by Purav Manot on 04/07/21.
//

import SwiftUI

struct ToolBar: View {
    @State private var bookmark: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var showAnswers: Bool
    @Binding var answerFieldShowing: Bool
    
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
    
    init(showAnswers: Binding<Bool>, answerFieldShowing: Binding<Bool>){
        self._showAnswers = showAnswers
        self._answerFieldShowing = answerFieldShowing
        impactFeedbackgenerator.prepare()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Group {
                ButtonSymbol("arrow.left.circle.fill"){
                    self.presentationMode.wrappedValue.dismiss()
                }
                .font(.title)
                
                ButtonSymbol("checkmark.circle", onToggle: "checkmark.circle.fill"){
                    endEditing()
                    withAnimation {
                        showAnswers.toggle()
                    }
                }
                .font(.title2)
                
                ButtonSymbol("keyboard", onToggle: "keyboard.chevron.compact.down"){
                    endEditing()
                    withAnimation(.easeInOut) {
                        impactFeedbackgenerator.impactOccurred()
                        answerFieldShowing.toggle()
                    }
                }
                
                ButtonSymbol("note"){
                    withAnimation(.easeInOut) {
                        //open scratchpad
                    }
                }
                
                ButtonSymbol("bookmark", onToggle: "bookmark.fill"){
                    //save paper
                }
                
                ButtonSymbol("arrow.right.circle.fill"){
                    endEditing()
                    answerFieldShowing = false
                    showAnswers.toggle()
                }
                .font(.title)
                
            }
            .frame(width: 40)
            .foregroundColor(.primary)
            .font(.body)
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(.all, 10)
        .background(Color.primary.opacity(0.8).colorInvert().clipShape(Capsule()).overlay(Capsule().stroke(lineWidth: 0.5).foregroundColor(.primary)).shadow(radius: 1))
    }
}


func endEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
