//
// Copyright (c) Purav Manot
//

import SwiftUI

struct AnswerField: View {
    @State public var text: String = ""
    
    init(){
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            TextEditor(text: $text)
                .font(.body)
                .foregroundColor(.white)
                .background(Color.black.clipShape(RoundedRectangle(cornerRadius: 10)))
                .opacity(0.8)
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(antialiased: true).foregroundColor(.secondary))
                .padding()
        }
    }
}

struct AnswerField_Previews: PreviewProvider {
    static var previews: some View {
        AnswerField()
    }
}
