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
    @EnvironmentObject var papers: PapersDatabase
    @State private var showMs: Bool = false
    @State var answerFieldShowing: Bool = false
    @State var dataSheetShowing = false
    @State var answers: [Answer] = []
    @State var answerDict: [QuestionIndex : String] = [:]
    @State var offset: CGSize = CGSize.zero
    @State var position: CGSize = CGSize.zero
    @State var partition = CGSize.zero
    
    @Environment(\.presentationMode) var presentationMode

    
    init(_ question: Question){
        self.question = question
    }
    var body: some View {
        GeometryReader { screen in
            ZStack(alignment: .bottom) {
                Group {
                    if !showMs {
                        PDFPageView(papers.cambridgePapers.first {$0.questions.contains(question)}!, pages: question.pages.map { $0.pageNumber })
                    } else {
                        AnswersView(paper: papers.cambridgePapers.first {$0.questions.contains(question)}!, fetchedAnswers: CodableAnswers(answers).answers, answersShowing: $showMs)
                    }
                }
                /*
                TabView {
                    PDFPageView(paper, pages: question.pages.map { $0.pageNumber })
                    PDFPageView(paper, pages: paper.pages.filter {$0.type == .datasheet}.map {$0.pageNumber})
                }
                .edgesIgnoringSafeArea(.all)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    /*DataSheet(paper: paper, isShowing: $dataSheetShowing)
                        .position(x: screen.size.width/2, y: (dataSheetShowing ? -160 : 120))
                        .hidden(!dataSheetShowing)*/
                */
                NewToolBar(showAnswers: $showMs, answerFieldShowing: $answerFieldShowing, dataSheetShowing: .constant(false))
                    .position(x: screen.size.width/2, y: screen.size.height - 20)
                
                AnswerField(papers.cambridgePapers.first {$0.questions.contains(question)}!, question, $answers)
                    .frame(height: 200)
                    .padding(.horizontal, 5)
                    .position(x: screen.size.width/2, y: screen.size.height + (answerFieldShowing ? -120 : 130))
            }
            .animation(.spring())
            .onAppear {
                answers.append(Answer(paper: papers.cambridgePapers.first {$0.questions.contains(question)}!, question: question, index: question.index))
            }
            .onChange(of: answerFieldShowing){ _ in
                print("AnswerField showing changed!")
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(Question(index: 1, pages: []))
            .environmentObject(PapersDatabase())
    }
}



