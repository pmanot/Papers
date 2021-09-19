//
//  NewToolBar.swift
//  Papers
//
//  Created by Purav Manot on 14/07/21.
//

import SwiftUI

struct NewToolBar: View {
    @State private var bookmark: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var showAnswers: Bool
    @Binding var answerFieldShowing: Bool
    @Binding var dataSheetShowing: Bool
    
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
    
    init(showAnswers: Binding<Bool>, answerFieldShowing: Binding<Bool>, dataSheetShowing: Binding<Bool>){
        self._showAnswers = showAnswers
        self._answerFieldShowing = answerFieldShowing
        self._dataSheetShowing = dataSheetShowing
        impactFeedbackgenerator.prepare()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Group {
                
                ButtonSymbol("checkmark.circle", onToggle: "checkmark.circle.fill"){
                    withAnimation {
                        showAnswers.toggle()
                    }
                }
                .font(.title3)
                
                ButtonSymbol("keyboard", onToggle: "keyboard.chevron.compact.down"){
                    withAnimation(.easeInOut) {
                        endEditing()
                        impactFeedbackgenerator.impactOccurred()
                        answerFieldShowing.toggle()
                    }
                }.font(.title3)
                
                ButtonSymbol("note"){
                    withAnimation(.easeInOut) {
                        //open scratchpad
                        dataSheetShowing.toggle()
                    }
                }
                
                ButtonSymbol("bookmark", onToggle: "bookmark.fill"){
                    //save paper
                }
                
            }
            .frame(width: 40)
            .foregroundColor(.primary)
            .font(.body)
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 20)
        }
        .padding(.all, 12)
        .background(Color.primary.colorInvert().opacity(0.8))
        .modifier(RoundedBorder())
    }
}

struct NewToolBar_Previews: PreviewProvider {
    static var previews: some View {
        NewToolBar(showAnswers: .constant(false), answerFieldShowing: .constant(false), dataSheetShowing: .constant(false))
    }
}

extension UIColor {
    public convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r, green: g, blue: b, alpha: 1)
        return
    }
}

extension Color {
    public init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat){
        self.init(UIColor(r/255, g/255, b/255))
    }
}
