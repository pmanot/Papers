//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct HomeView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    @State private var isExpanded: Bool = false

    // TODO: Move this to PapersDatabase, and shuffle it there.

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Questions for you:")
                            .font(.title3, weight: .heavy)
                        QuestionCollectionView(papersDatabase: applicationStore.papersDatabase)
                            .frame(height: 400)
                    }
                    .padding(10)
                    
                    // MARK: Development
                    /*
                    VStack(alignment: .leading) {
                        Text("Your decks:")
                            .font(.title3, weight: .heavy)
                        
                        SolvedPapersScrollView(papersDatabase: papersDatabase, isExpanded: $isExpanded)
                    }
                    .padding(10)
                    */
                    
                    VStack(alignment: .leading) {
                        Text("Papers you've solved:")
                            .font(.title3, weight: .heavy)

                        SolvedPapersScrollView(papersDatabase: applicationStore.papersDatabase, isExpanded: $isExpanded)
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
    struct QuestionCollectionView: View {
        @ObservedObject var papersDatabase: PapersDatabase
        @State private var selectedPaperNumber: CambridgePaperNumber = .paper2
        @State private var selectedPageCount: Int = 1
        private var filteredBundles: [CambridgePaperBundle] {
            papersDatabase.oldPaperBundles.filter { $0.metadata.paperNumber == selectedPaperNumber }
        }
        private func pageCountFilter(_ question: Question) -> Bool {
            switch selectedPageCount {
                case 1:
                    return question.pages.count == selectedPageCount
                case 2:
                    return question.pages.count > 1 && question.pages.count < 4
                case 3:
                    return question.pages.count > 3
                default:
                    return true
            }
        }
        
        var body: some View {
            VStack {
                VStack(spacing: 5) {
                    Picker("", selection: $selectedPaperNumber){
                        ForEach([CambridgePaperNumber.paper2, CambridgePaperNumber.paper3, CambridgePaperNumber.paper4, CambridgePaperNumber.paper5], id: \.self){ number in
                            Text("Paper \(number.rawValue)")
                                .tag(number)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(5)
                    
                    Picker("", selection: $selectedPageCount){
                            Text("1 page")
                                .tag(Int(1))
                            Text("2 - 3 pages")
                                .tag(Int(2))
                            Text("4+ pages")
                                .tag(Int(3))
                    }
                    .pickerStyle(.segmented)
                    .padding(5)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(filteredBundles, id: \.metadata.paperCode) { bundle in
                            if bundle.questionPaper != nil {
                                ForEach(enumerating: bundle.questionPaper!.questions.filter(pageCountFilter) , id: \.id){ (index, question) in
                                    QuestionListCell(question: question, bundle: bundle)
                                }
                            }
                        }
                    }
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
                        .frame(width: 310)
                        .frame(minHeight: 300)
                        
                    }
                    .padding(10)
                }
            }
        }
    }
}

extension HomeView.QuestionCollectionView {
    private struct QuestionListCell: View {
        let question: Question
        let bundle: CambridgePaperBundle

        var body: some View {
            NavigationLink(destination: QuestionView(question, bundle: bundle)) {
                VStack {
                    Text(question.rawText)
                        .padding()
                        .background(Color.background.cornerRadius(20))
                        .border(Color.primary, width: 0.5, cornerRadius: 20)

                    HStack {
                        Text(question.metadata.subject.rawValue)
                            .fontWeight(.regular)
                            .padding(8)
                            .background(Color.background)
                            .border(Color.secondary, width: 0.5, cornerRadius: 10, style: .circular)
                        Text("Q\(question.index.number)")
                            .fontWeight(.regular)
                            .padding(8)
                            .background(Color.background)
                            .border(Color.secondary, width: 0.5, cornerRadius: 10, style: .circular)
                        Text("\(question.pages.count) page\(question.pages.count > 1 ? "s" : "")")
                            .fontWeight(.regular)
                            .padding(8)
                            .background(Color.background)
                            .border(Color.secondary, width: 0.5, cornerRadius: 10, style: .circular)
                    }
                    .padding(5)
                }
                .padding(5)
                .frame(width: 280, height: 300)
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
                .preferredColorScheme(.dark)
        }
        .environmentObject(PapersDatabase())
    }
}
