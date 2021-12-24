//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct HomeView: View {
    @ObservedObject var papersDatabase: PapersDatabase

    @State private var isExpanded: Bool = false

    // TODO: Move this to PapersDatabase, and shuffle it there.
    var allQuestions: [Question] {
        papersDatabase.paperBundles
            .compactMap({ $0.questionPaper })
            .questions()
            .sorted(by: { $0.id.uuidString < $1.id.uuidString })
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Questions for you:")
                            .font(.title3, weight: .heavy)
                        questionCollectionView
                            .frame(height: 300)
                    }
                    .padding(10)

                    VStack(alignment: .leading) {
                        Text("Papers you've solved:")
                            .font(.title3, weight: .heavy)
                            .zIndex(1)

                        SolvedPapersScrollView(papersDatabase: papersDatabase, isExpanded: $isExpanded)
                    }
                    .padding(10)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Home")
        }
    }

}

extension HomeView {
    private struct QuestionListCell: View {
        let question: Question

        var body: some View {
            NavigationLink(destination: QuestionView(question)) {
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.nearDark)
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
                .padding(5)
                .frame(width: 280, height: 300)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var questionCollectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(allQuestions, id: \.hashValue) { question in
                    QuestionListCell(question: question)
                }
            }
        }
    }

    struct SolvedPapersScrollView: View {
        @ObservedObject var papersDatabase: PapersDatabase

        @Binding var isExpanded: Bool

        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach([String](papersDatabase.solvedPapers.keys.sorted()), id: \.self) { paperCode in
                        SolvedPaperCollectionView(
                            solvedPapers: papersDatabase.solvedPapers[paperCode]!,
                            expanded: $isExpanded
                        )
                        .frame(width: 320)
                        .frame(minHeight: 280)
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(papersDatabase: PapersDatabase())
        }
        .environmentObject(PapersDatabase())
    }
}
