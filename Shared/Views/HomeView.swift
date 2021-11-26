//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct HomeView: View {
    @EnvironmentObject var applicationStore: ApplicationStore

    // TODO: Move this to PapersDatabase, and shuffle it there.
    var allQuestions: [Question] {
        applicationStore.papersDatabase.paperBundles.compactMap { $0.questionPaper }.questions()
    }

    var body: some View {
        VStack {
            Text("Welcome, User")
                .font(.largeTitle)
                .fontWeight(.bold)

            questionListView
                .frame(height: 400)
        }
        .navigationTitle("Home")
    }

    private var questionListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(allQuestions, id: \.hashValue) { question in
                    QuestionListCell(question: question)
                }
            }
        }
    }

    private struct QuestionListCell: View {
        let question: Question

        var body: some View {
            NavigationLink(destination: QuestionView(question)) {
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .opacity(0.2)
                        .overlay(
                            Text(question.rawText)
                                .padding()
                        )
                        .border(Color.primary, width: 0.5, cornerRadius: 20)

                    HStack {
                        Text(question.metadata.questionPaperCode)
                            .fontWeight(.regular)
                            .padding(8)
                            .border(Color.primary, width: 0.5, cornerRadius: 10, style: .circular)
                        Text(String(question.index.number))
                            .fontWeight(.regular)
                            .frame(width: 20)
                            .padding(7)
                            .border(Color.primary, width: 0.5, cornerRadius: 10, style: .circular)
                    }
                    .padding(5)
                    .opacity(0.6)
                }
                .frame(width: 300, height: 300)
                .padding()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(ApplicationStore())
        }
    }
}
