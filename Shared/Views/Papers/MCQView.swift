//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct MCQView: View {
    @Environment(\.presentationMode) var presentationMode
    var paperBundle: CambridgePaperBundle
    
    @State var answers: [Answer] = (1...40).map { Answer(index: QuestionIndex($0), value: .multipleChoice(choice: .none)) }
    @State private var showResults: Bool = false
    
    let timer = Timer.publish(every: 1, on: .current, in: .default, options: .none)
    
    private var correctAnswersByIndex: [QuestionIndex : AnswerValue] {
        paperBundle.markScheme?.metadata.answers.getAnswersByIndex() ?? (1...40).map { Answer(index: QuestionIndex($0), value: .multipleChoice(choice: .A)) }.getAnswersByIndex()
    }
    
    @State private var solvedPaper: SolvedPaper? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            WrappedPDFView(pdf: paperBundle.questionPaper!.pdf)
                .background(Color.white)
                .edgesIgnoringSafeArea(.top)
            
            
            MCQAnswerOverlay(answers: $answers, correctAnswers: correctAnswersByIndex, onSave: {
                solvedPaper = SolvedPaper(bundle: paperBundle, answers: answers)
                if solvedPaper != nil {
                    showResults.toggle()
                }
            })
            
        }
        .sheet(isPresented: $showResults, onDismiss: {presentationMode.wrappedValue.dismiss()}){
            MCQSolvedView($solvedPaper)
        }
    }
}

struct MCQView_Previews: PreviewProvider {
    static var previews: some View {
        MCQView(paperBundle: CambridgePaperBundle(questionPaper: PapersDatabase.exampleMCQ, markScheme: nil))
    }
}


struct MCQAnswerOverlay: View {
    @Binding var answers: [Answer]
    @State var selectedIndex: QuestionIndex = QuestionIndex(1)
    @State var timeTaken: TimeInterval = .zero
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    let correctAnswers: Answers
    var onSave: () -> ()
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(selectedIndex.number)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color.primaryInverted)
                    .border(.black, width: 2, cornerRadius: 10)
                Spacer()
                SymbolButton("checkmark.circle.fill"){
                    onSave()
                }
                .buttonStyle(PlainButtonStyle())
                .font(.system(size: 40), weight: .light)
                .foregroundColor(.black)
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .frame(width: answers[selectedIndex.number - 1].selected(.none) ? 0 : Screen.size.width, height: 2)
                    .foregroundColor(.green)
                Line()
                    .stroke()
                    .frame(height: 2)
                TabView(selection: $selectedIndex) {
                    ForEach(answers, id: \.index){ answer in
                        HStack(spacing: 30) {
                            Button(action: {buttonPressed(selection: .A)}){
                                Text("A")
                            }
                            .modifier(MCQButtonStyle())
                            .foregroundColor(answerColor(selected: answer.value, correct: correctAnswers[answer.index]!, for: .multipleChoice(choice: .A)))
                            
                            Button(action: {buttonPressed(selection: .B)}){
                                Text("B")
                            }
                            .modifier(MCQButtonStyle())
                            .foregroundColor(answerColor(selected: answer.value, correct: correctAnswers[answer.index]!, for: .multipleChoice(choice: .B)))
                            
                            Button(action: {buttonPressed(selection: .C)}){
                                Text("C")
                            }
                            .modifier(MCQButtonStyle())
                            .foregroundColor(answerColor(selected: answer.value, correct: correctAnswers[answer.index]!, for: .multipleChoice(choice: .C)))
                            
                            Button(action: {buttonPressed(selection: .D)}){
                                Text("D")
                            }
                            .modifier(MCQButtonStyle())
                            .foregroundColor(answerColor(selected: answer.value, correct: correctAnswers[answer.index]!, for: .multipleChoice(choice: .D)))
                        }
                        .padding(.vertical, 10)
                        .tag(answer.index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .background(Color.primaryInverted.edgesIgnoringSafeArea(.all))
                .frame(height: 100)
            }
        }
        .onReceive(timer){ _ in
            timeTaken += 0.01
        }
        
    }
}

extension MCQAnswerOverlay {
    func completionAnimation(selection: MCQSelection){
        if selectedIndex.number != 40 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                withAnimation(.easeOut(duration: 0.5)) {
                    if answers[selectedIndex.number - 1].selected(selection) {
                        selectedIndex = answers[selectedIndex.number].index
                    }
                }
            }
        }
    }
    
    func buttonPressed(selection: MCQSelection){
        withAnimation {
            answers[selectedIndex.number - 1].toggleChoice(selection, timed: timeTaken)
            timeTaken = .zero
        }
        
        completionAnimation(selection: selection)
    }
}

struct MCQButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2, weight: .black)
            .foregroundColor(Color.primary)
            .frame(width: 48, height: 48)
            .background(Circle())
            .padding(2)
            .border(Color.primary, width: 2, cornerRadius: .infinity, style: .circular)
    }
}


func toggleMCQValue(answer: inout Answer, value: MCQSelection){
    switch answer.value {
        case .multipleChoice(choice: .none):
            answer.updateValue(value: AnswerValue.multipleChoice(choice: value))
        default:
            answer.updateValue(value: AnswerValue.multipleChoice(choice: .none))
    }
}


func answerColor(selected: AnswerValue, correct: AnswerValue, for button: AnswerValue) -> Color {
    if !(selected == .multipleChoice(choice: .none)) {
        if button == correct {
            return Color.green
        }
        
        if selected == button {
            return selected == correct ? Color.green : Color.red
        }
        
        return Color.primaryInverted
    }
    return Color.primaryInverted
}
