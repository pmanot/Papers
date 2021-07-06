//
// Copyright (c) Purav Manot
//
/*
let jsonData = try! JSONEncoder().encode(CodableAnswers(answers))
let jsonString = String(data: jsonData, encoding: .utf8)
directory.write(jsonString!, to: question.paper.paperCode)
let readJsonString = directory.read(from: question.paper.paperCode)
let decodedData = try! JSONDecoder().decode(CodableAnswers.self, from: Data(directory.read(from: question.paper.paperCode).utf8))
print(decodedData) */

import SwiftUI

struct QuestionView: View {
    let question: Question
    
    @State private var showMs: Bool = false
    @State var answerFieldShowing: Bool = false
    @State var answers: [Answer] = [Answer(paper: QuestionPaper.example)]
    @State var answerDict: [QuestionIndex : String] = [:]
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var codableAnswers: Answers

    
    init(_ question: Question){
        self.question = question
    }
    
    init(_ paper: QuestionPaper){
        self.question = Question(paper: paper, page: Array(0..<paper.pdf.pageCount))
    }
    
    var body: some View {
        GeometryReader { screen in
            ZStack(alignment: .bottom) {
                Group {
                    switch showMs {
                        case true:
                            AnswersView(question: question, fetchedAnswers: codableAnswers.fetch().answers, answersShowing: $showMs)
                        case false:
                            PDFPageView(question.paper, pages: question.pages)
                    }
                }
                
                ToolBar(showAnswers: $showMs, answerFieldShowing: $answerFieldShowing)
                    .padding()
                    .position(x: screen.size.width/2, y: !answerFieldShowing ? (screen.size.height - 40) : 40 )
                    .hidden(showMs)
                
                AnswerField(question, $answers)
                    .environmentObject(codableAnswers)
                    .frame(height: 250)
                    .position(x: screen.size.width/2, y: screen.size.height - (answerFieldShowing ? 120 : -130))
            }
            .animation(.spring())
            .navigationBarHidden(true)
            .onChange(of: answerFieldShowing){ _ in
                print("AnswerField showing changed!")
                if answers[0].text != "" {
                    codableAnswers.save(answers)
                }
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(QuestionPaper.example.questions[0])
            .environmentObject(Answers())
    }
}
