//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct MCQAnswerOverlay: View {
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    let bundle: CambridgePaperBundle
    let markschemeAnswers: [QuestionIndex : MultipleChoiceAnswer]
    
    @State private var solvedPaper: SolvedPaper! = nil
    @State private var answers: [QuestionIndex : MultipleChoiceAnswer] = Dictionary(uniqueKeysWithValues: [Int](1...40).map { (QuestionIndex($0), MultipleChoiceAnswer(index: QuestionIndex($0), value: MultipleChoiceValue.none)) } )
    @State private var selectedIndex: QuestionIndex = QuestionIndex(1)
    @State private var timeTaken: TimeInterval = .zero
    @State private var correctAnswerTint: Bool = true
    @State private var showingResults: Bool = false
    @Binding var isShowing: Bool
    @Environment(\.presentationMode) var presentationMode
    
    init(bundle: CambridgePaperBundle, showing: Binding<Bool>){
        self.bundle = bundle
        self.markschemeAnswers = bundle.markScheme?.metadata.multipleChoiceAnswers ?? [:]
        self._isShowing = showing
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                /*
                SymbolButton("chevron.left.circle.fill") {
                    goToPreviousIndex()
                }
                .font(.title2, weight: .heavy)
                .background(Color.white.frame(width: 20, height: 20).cornerRadius(.infinity))
                */
                Text("\(selectedIndex.index)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color.background)
                    .border(Color.dark, width: 2, cornerRadius: 10)
                /*
                SymbolButton("chevron.right.circle.fill") {
                    goToNextIndex()
                }
                .font(.title2, weight: .heavy)
                .background(Color.white.frame(width: 20, height: 20).cornerRadius(.infinity))
                */
                Spacer()
                Button(action: save){
                    Image(systemName: .checkmarkCircleFill)
                        .foregroundColor(.dark)
                        .font(.system(size: 38), weight: .semibold)
                        .background {
                            Color.white
                                .frame(width: 35, height: 35)
                                .cornerRadius(.infinity)
                        }
                }
            }
            .foregroundColor(.dark)
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .frame(width: answers[selectedIndex]!.value == .none ? 0 : Screen.size.width, height: 5)
                    .foregroundColor(Color.systemIndigo)
                Divider()
                TabView(selection: $selectedIndex) {
                    ForEach([Int](1...40).map { QuestionIndex($0) }){ index in
                        HStack(spacing: 30) {
                            ForEach([MultipleChoiceValue.A, MultipleChoiceValue.B, MultipleChoiceValue.C, MultipleChoiceValue.D]){ value in
                                Button(action: {buttonPressed(value: value)}){
                                    Text(value.rawValue)
                                }
                                .modifier(MCQButtonStyle())
                                .foregroundColor(getAnswerColor(selected: answers[index]!.value, correct: markschemeAnswers[index]!.value, for: value))
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .background(Color.background)
                .frame(height: 80)
            }
        }
        .onReceive(timer){ _ in
            timeTaken += 0.01
        }
        .sheet(isPresented: $showingResults, onDismiss: { presentationMode.wrappedValue.dismiss() } ){
            MCQSolvedView($solvedPaper)
        }
    }
}

extension MCQAnswerOverlay {
    private func completionAnimation(value: MultipleChoiceValue){
        if selectedIndex.index != 40 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                withAnimation(.easeOut(duration: 0.5)) {
                    if answers[selectedIndex]!.value != .none {
                        selectedIndex = QuestionIndex(selectedIndex.index + 1)
                    }
                }
            }
        }
    }
    
    private func buttonPressed(value: MultipleChoiceValue){
        withAnimation {
            answers[selectedIndex]!.toggleChoice(value, timed: timeTaken)
            timeTaken = .zero
        }
        
        completionAnimation(value: value)
    }
    
    private func toggleMCQValue(answer: inout Answer, value: MCQSelection){
        switch answer.value {
            case .multipleChoice(choice: .none):
                answer.updateValue(value: AnswerValue.multipleChoice(choice: value))
            default:
                answer.updateValue(value: AnswerValue.multipleChoice(choice: .none))
        }
    }

    private func getAnswerColor(selected: MultipleChoiceValue, correct: MultipleChoiceValue, for button: MultipleChoiceValue) -> Color {
        if !(selected == .none) {
            if correctAnswerTint {
                    if button == correct {
                        return Color.green
                    }
                    
                    if selected == button {
                        return selected == correct ? Color.green : Color.red
                    }
                    
                    return Color.background
            } else {
                if selected == button {
                    return .systemIndigo
                }
            }
        }
        return Color.background
    }
    
    private func goToNextIndex() {
        if selectedIndex.index != 40 {
            withAnimation(.easeIn) {
                selectedIndex = QuestionIndex(selectedIndex.index + 1)
            }
        }
    }
    
    private func goToPreviousIndex() {
        if selectedIndex.index != 1 {
            withAnimation(.easeIn) {
                selectedIndex = QuestionIndex(selectedIndex.index - 1)
            }
        }
    }
    
    private func save(){
        solvedPaper = SolvedPaper(bundle: bundle, answers: answers)
        if solvedPaper != nil {
            self.showingResults.toggle()
        }
    }
}

extension MCQAnswerOverlay {
    struct DebugOverlay: View {
        let markschemeAnswers: [QuestionIndex : AnswerValue]
        var body: some View {
            VStack {
                ForEach(0..<40){ index in
                    Text("\(index) : \(markschemeAnswers[QuestionIndex(index + 1)]!.getValue())")
                }
            }
        }
    }
    
    
    static var initialisedAnswers: [Answer] {
        return (1...40).map { Answer(index: QuestionIndex($0), value: .multipleChoice(choice: .none)) }
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

/*
struct MCQAnswerOverlay_Previews: PreviewProvider {
    static var previews: some View {
        MCQAnswerOverlay(answers: Answer, markschemeAnswers: <#[QuestionIndex : AnswerValue]#>, onSave: <#() -> ()#>)
    }f
}
*/
