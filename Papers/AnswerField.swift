//
//  AnswerField.swift
//  Papers
//
//  Created by Purav Manot on 23/06/21.
//

import SwiftUI

struct AnswerField: View {
    @State var text: String = ""
    var body: some View {
        ZStack(alignment: .topTrailing) {
            TextEditor(text: $text)
                .foregroundColor(.white)
                .font(.body, weight: .bold)
                .frame(width: 350)
                .opacity(0.4)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(y: 200)
            HStack {
                Button(action: {
                    hideKeyboard()
                }){
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 30, height: 30)
                        .padding()
                }
                .visibleIfKeyboardActive()
            }
        }
    }
}

struct AnswerField_Previews: PreviewProvider {
    static var previews: some View {
        AnswerField()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
