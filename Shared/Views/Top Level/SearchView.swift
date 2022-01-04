//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct SearchView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    @State var searchText: String = ""
    var questions: [Question] {
        return applicationStore.papersDatabase.questions.filter({ question in
            question.rawText.match(searchText)
        })
    }
    
    var paperBundles: [CambridgePaperBundle] {
        return applicationStore.papersDatabase.paperBundles.filter({ paperBundle in
            paperBundle.metadata.rawText.match(searchText)
        })
    }
    var body: some View {
        ListView(paperBundles: paperBundles, searchText: $searchText)
            .navigationTitle("Search")
            .listStyle(GroupedListStyle())
            .navigationSearchBar {
                SearchBar(text: $searchText)
            }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
                .environmentObject(ApplicationStore())
        }
    }
}

extension SearchView {
    struct ListView: View {
        let paperBundles: [CambridgePaperBundle]
        @Binding var searchText: String
        
        var body: some View {
            List(paperBundles, id: \.metadata.paperCode){ bundle in
                Row(searchText: $searchText, paperBundle: bundle)
                    .buttonStyle(PlainButtonStyle())
            }
            .listStyle(GroupedListStyle())
        }
    }
}


extension SearchView.ListView {
    struct Row: View {
        @Binding var searchText: String
        let paperBundle: CambridgePaperBundle
        
        var body: some View {
            NavigationLink(destination: PaperContentsView(bundle: paperBundle, search: $searchText)) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(paperBundle.metadata.subject.rawValue)")
                            .font(.title3, weight: .black)
                        
                        Text(paperBundle.metadata.questionPaperCode)
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                    }
                    
                    HStack {
                        Text("\(paperBundle.metadata.month.compact())")
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                        
                        Text("20\(paperBundle.metadata.year)")
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                        
                        Text("Paper \(paperBundle.metadata.paperNumber.rawValue)")
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                        
                        Text("Variant \(paperBundle.metadata.paperVariant.rawValue)")
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                    }
                    
                    if paperBundle.metadata.paperType == .questionPaper {
                        HStack {
                            Text("\(paperBundle.metadata.numberOfQuestions) questions  |  \(paperBundle.questionPaper!.pages.count) pages")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundColor(.secondary)
                                .padding(6)
                            
                            if paperBundle.metadata.paperNumber == .paper1 && paperBundle.markScheme != nil {
                                if !paperBundle.markScheme!.metadata.answers.isEmpty {
                                    Group {
                                        Image(systemName: .aCircleFill)
                                        Image(systemName: .bCircleFill)
                                        Image(systemName: .cCircleFill)
                                        Image(systemName: .dCircleFill)
                                    }
                                    .font(.headline)
                                    .frame(width: 15)
                                }
                            }
                        }
                        
                    } else {
                        Text("Markscheme")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(.secondary)
                            .padding(6)
                    }
                    
                }
                .padding(5)
                
            }
            .buttonStyle(PlainButtonStyle())
            .buttonStyle(PlainButtonStyle())
            .contextMenu {
                Label("Markscheme", systemImage: "doc.on.clipboard")
                
                Button {
                    
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}
