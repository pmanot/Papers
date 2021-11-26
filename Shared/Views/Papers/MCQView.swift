//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct MCQView: View {
    @EnvironmentObject var papersDatabase: PapersDatabase
    @State var answers: [Answer] = (1...40).map { Answer(index: QuestionIndex($0), value: .multipleChoice(choice: .none)) }
    @State var saveAnswers: Bool = false
    
    var paper: CambridgeMultipleChoicePaper
    
    var body: some View {
        ZStack(alignment: .bottom) {
            WrappedPDFView(pdf: PapersDatabase.exampleMCQ!)
                .background(Color.white)
            MCQAnswerOverlay(answers: $answers, save: $saveAnswers)
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: saveAnswers){ _ in
            print(answers)
            saveAnswers = false
        }
    }
}

struct MCQView_Previews: PreviewProvider {
    static var previews: some View {
        MCQView(paper: CambridgeMultipleChoicePaper(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_qp_11", ofType: ".pdf")!), metadata: CambridgePaperMetadata(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_qp_11", ofType: ".pdf")!))))
    }
}


struct MCQAnswerOverlay: View {
    @Binding var answers: [Answer]
    @Binding var save: Bool
    @State var selectedIndex: QuestionIndex = QuestionIndex(1)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(selectedIndex.number)")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer()
                SymbolButton("chevron.right.circle.fill"){
                    save.toggle()
                }
                .buttonStyle(PlainButtonStyle())
                .font(.largeTitle)
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .frame(width: answers[selectedIndex.number - 1].selected(.none) ? 0 : Screen.size.width, height: 2)
                    .foregroundColor(.green)
                TabView(selection: $selectedIndex) {
                    ForEach(answers, id: \.index){ answer in
                        HStack {
                            Button(action: {
                                withAnimation {
                                    answers[selectedIndex.number - 1].toggleChoice(.A)
                                }
                                if selectedIndex.number != 40 {
                                    withAnimation(after: DispatchTimeInterval.milliseconds(1000)) {
                                        if answers[selectedIndex.number - 1].selected(.A) {
                                            selectedIndex = answers[selectedIndex.number].index
                                        }
                                    }
                                }
                            }){
                                Text("A")
                            }
                            .modifier(MCQButtonStyle())
                            .foregroundColor(answer.selected(.A) ? .green : .primaryInverted)
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 10)
                            
                            Button(action: {
                                withAnimation {
                                    answers[selectedIndex.number - 1].toggleChoice(.B)
                                }
                                if selectedIndex.number != 40 {
                                    withAnimation(after: DispatchTimeInterval.milliseconds(1000)) {
                                        if answers[selectedIndex.number - 1].selected(.B) {
                                            selectedIndex = answers[selectedIndex.number].index
                                        }
                                    }
                                }
                            }){
                                Text("B")
                            }
                            .modifier(MCQButtonStyle())
                            .foregroundColor(answer.selected(.B) ? .green : .primaryInverted)
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 10)
                            
                            Button(action: {
                                withAnimation {
                                    answers[selectedIndex.number - 1].toggleChoice(.C)
                                }
                                if selectedIndex.number != 40 {
                                    withAnimation(after: DispatchTimeInterval.milliseconds(1000)) {
                                        if answers[selectedIndex.number - 1].selected(.C) {
                                            selectedIndex = answers[selectedIndex.number].index
                                        }
                                    }
                                }
                            }){
                                Text("C")
                            }
                            .modifier(MCQButtonStyle())
                            .foregroundColor(answer.selected(.C) ? .green : .primaryInverted)
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 10)
                            
                            Button(action: {
                                withAnimation {
                                    answers[selectedIndex.number - 1].toggleChoice(.D)
                                }
                                if selectedIndex.number != 40 {
                                    withAnimation(after: DispatchTimeInterval.milliseconds(1000)) {
                                        if answers[selectedIndex.number - 1].selected(.D) {
                                            selectedIndex = answers[selectedIndex.number].index
                                        }
                                    }
                                }
                            }){
                                Text("D")
                            }
                            .modifier(MCQButtonStyle())
                            .foregroundColor(answer.selected(.D) ? .green : .primaryInverted)
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 10)
                        }
                        .padding(.vertical, 10)
                        .tag(answer.index)
                    }
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .indexViewStyle(PageIndexViewStyle())
                .background(Color.primaryInverted.border(.black))
                .frame(height: 130)
            }
        }
        
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
