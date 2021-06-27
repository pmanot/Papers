//
// Copyright (c) Purav Manot
//

import SwiftUIX

struct AnswerField: View {
    @State var text: String = ""
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            TextEditor(text: $text)
                .foregroundColor(.white)
                .frame(width: 350)
                .opacity(0.4)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(y: 200)
            
            Button {
                Keyboard.dismiss()
            } label: {
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .foregroundColor(.green)
                    .frame(width: 30, height: 30)
                    .padding()
            }
        }
    }
}

struct AnswerField_Previews: PreviewProvider {
    static var previews: some View {
        AnswerField()
    }
}
