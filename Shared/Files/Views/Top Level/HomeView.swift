//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct HomeView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded: Bool = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Questions for you:")
                            .font(.title3, weight: .heavy)
                            .padding()
                        QuestionCollectionView(papersDatabase: applicationStore.papersDatabase)
                            .padding(.vertical, 10)
                    }
                    
                    Divider()
                    
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
                            .padding()

                        SolvedPapersScrollView(papersDatabase: applicationStore.papersDatabase, isExpanded: $isExpanded)
                    }
                    .padding(10)
                    .padding(.bottom, 30)
                    
                    Divider()
                }
            }
            .navigationTitle("Home")
        }
        .background(Color.systemGroupedBackground)
    }

}

extension HomeView {
    struct QuestionCollectionView: View {
        @ObservedObject var papersDatabase: PapersDatabase
        @State private var selectedPaperNumber: CambridgePaperNumber = .paper2
        @State private var selectedPageCount: Int = 1
        private var filteredBundles: [CambridgePaperBundle] {
            papersDatabase.paperBundles.filter { $0.metadata.paperNumber == selectedPaperNumber }
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
            VStack(alignment: .leading) {
                /*
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
                 */
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(filteredBundles.indexedQuestions(), id: \.1.self) { (index, question) in
                            QuestionListCell(question: question, bundle: filteredBundles[index])
                                .padding()
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
        @Environment(\.colorScheme) var colorScheme
        let question: Question
        let bundle: CambridgePaperBundle

        var body: some View {
            NavigationLink(destination: QuestionView(question, bundle: bundle)) {
                GroupBox {
                    switch colorScheme {
                        case .dark:
                            Text(question.getContents(pdf: bundle.questionPaper!.pdf))
                                .colorInvert()
                                .frame(width: 250, height: 220)
                        default:
                            Text(question.getContents(pdf: bundle.questionPaper!.pdf))
                                .frame(width: 200, height: 200)
                                
                    }
                    
                    Divider()
                    
                    HStack {
                        Text(question.details.subject?.rawValue ?? "")
                            .modifier(TagTextStyle())
                        Spacer()
                        HStack {
                            Text("\(question.pages.count) page\(question.pages.count > 1 ? "s" : "")")
                                .modifier(TagTextStyle())
                            Text("\(question.index.parts.count) part\(question.index.parts.count > 1 ? "s" : "")")
                                .modifier(TagTextStyle())
                        }
                    }
                    .padding(.vertical, 5)
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
