//
// Copyright (c) Purav Manot
//

import SwiftUI

struct QuestionView: View {
    var question: Question
    var pages: [Int]
    @State private var showMs: Bool = false
    @State var answerFieldShowing: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var keyboard: Keyboard

    
    init(_ question: Question = Question(paper: Paper.example, page: [0, 1])){
        self.question = question
        self.pages = question.pages
    }
    
    var body: some View {
        GeometryReader { screen in
            ZStack(alignment: .bottom) {
                Group {
                    switch showMs {
                        case true:
                        if question.answer != nil {
                            PdfView(MarkScheme.example, pages: question.answer!.pages)
                        }
                        case false:
                            PdfView(Paper.example, pages: question.pages)
                    }
                }
                
                Toolbar(showAnswers: $showMs, answerFieldShowing: $answerFieldShowing)
                    .padding()
                    .position(x: screen.size.width/2, y: screen.size.height - (answerFieldShowing ? 300 : 40))
                AnswerField()
                    .frame(height: 200)
                    .position(x: screen.size.width/2, y: screen.size.height - (answerFieldShowing ? 100 : -90))
            }
            .navigationBarHidden(true)
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(Paper.example.questions[0])
            .environmentObject(Keyboard())
    }
}

extension QuestionView {
    struct Toolbar: View {
        @State private var bookmark: Bool = false
        @Environment(\.presentationMode) var presentationMode
        @Binding var showAnswers: Bool
        @Binding var answerFieldShowing: Bool
        @EnvironmentObject var keyboard: Keyboard
        
        init(showAnswers: Binding<Bool>, answerFieldShowing: Binding<Bool>){
            self._showAnswers = showAnswers
            self._answerFieldShowing = answerFieldShowing
        }
        
        var body: some View {
            HStack(alignment: .center) {
                Group {
                    ButtonSymbol("arrow.left.circle.fill"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .font(.title)
                    
                    ButtonSymbol("checkmark.circle", onToggle: "checkmark.circle.fill"){
                        withAnimation {
                            showAnswers.toggle()
                        }
                    }
                    .font(.title2)
                    
                    ButtonSymbol("keyboard", onToggle: "keyboard.chevron.compact.down"){
                        withAnimation(.easeInOut) {
                            keyboard.showing.toggle()
                            answerFieldShowing.toggle()
                        }
                    }
                    
                    ButtonSymbol("bookmark", onToggle: "bookmark.fill"){
                        
                    }
                    
                }
                .frame(width: 40)
                .foregroundColor(.primary)
                .font(.body)
                .buttonStyle(PlainButtonStyle())
                
            }
            .padding(.all, 10)
            .background(Color.primary.opacity(0.8).colorInvert().clipShape(Capsule()).overlay(Capsule().stroke(lineWidth: 0.5).foregroundColor(.primary)))
            .shadow(radius: 2)
        }
    }
}

struct ButtonSymbol: View {
    @State private var toggled: Bool = false
    
    private var systemName: String
    private var toggledSystemName: String = ""
    var action: () -> Void = {}
    
    init(_ systemName: String, onToggle: String = "", _ action: @escaping () -> Void){
        self.systemName = systemName
        self.toggledSystemName = onToggle
        self.action = action
    }
    
    init(_ systemName: String, _ action: @escaping () -> Void){
        self.systemName = systemName
        self.toggledSystemName = systemName
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            self.action()
            toggled.toggle()
        }){
            Image(systemName: self.toggled ? toggledSystemName : systemName)
        }
    }
}

class Keyboard: ObservableObject {
    var showing: Bool = false
    var mode: UIKeyboardType?
}
