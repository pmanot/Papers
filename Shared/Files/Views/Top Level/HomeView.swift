//
// Copyright (c) Purav Manot
//

import PDFKit
import SwiftUIX

struct HomeView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var isSolvedPapersExpanded: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                dailyQuestions
                    .padding(.bottom)
                
                solvedPapers
            }
            .padding()
        }
        .background(Color.systemBackground)
        .navigationTitle("Home")
    }
    
    var dailyQuestions: some View {
        VStack(alignment: .leading) {
            Text("Questions For You")
                .font(.title2.weight(.bold))
                .padding(.horizontal, .small)

            QuestionCollectionView(papersDatabase: applicationStore.papersDatabase)
        }
    }
    
    var solvedPapers: some View {
        VStack(alignment: .leading) {
            Text("Solved Papers")
                .font(.title2.weight(.bold))
                .padding(.horizontal, .small)
            
            SolvedPapersScrollView(
                papersDatabase: applicationStore.papersDatabase,
                isExpanded: $isSolvedPapersExpanded
            )
        }
    }
}

extension HomeView {
    struct QuestionCollectionView: View {
        @ObservedObject var papersDatabase: PapersDatabase
        
        @State var selectedPaperNumber: CambridgePaperNumber = .paper2
        @State var selectedPageCount: Int = 1
        
        var filteredBundles: [CambridgePaperBundle] {
            papersDatabase.paperBundles.filter { $0.metadata.paperNumber == selectedPaperNumber }
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(filteredBundles.indexedQuestions(), id: \.1.self) { (index, question) in
                            QuestionListCell(question: question, bundle: filteredBundles[index])
                                .padding(.small)
                        }
                    }
                    .padding(.leading, .small)
                }
            }
        }
        
        func pageCountFilter(_ question: Question) -> Bool {
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
    }
    
    private struct SolvedPapersScrollView: View {
        @ObservedObject var papersDatabase: PapersDatabase
        
        @Binding var isExpanded: Bool
        
        var data: [String] {
            papersDatabase.solvedPapers.keys.sorted()
        }
        
        var body: some View {
            if !data.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top) {
                        ForEach(data, id: \.self) { paperCode in
                            SolvedPaperCollectionView(
                                solvedPapers: papersDatabase.solvedPapers[paperCode]!,
                                expanded: $isExpanded
                            )
                            .frame(width: 310)
                            .frame(minHeight: 300)
                            
                        }
                        .padding(15)
                    }
                }
            } else {
                Text("Papers will appear here as you solve them.")
                    .font(.title3, weight: .semibold)
                    .foregroundColor(.secondary)
                    .padding()
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
                                .frame(width: 250, height: 220)
                            
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

// MARK: - Development Preview -

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
