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
        @ViewBuilder var destinationView: some View {
            switch paperBundle.metadata.paperType {
                case .markscheme:
                    Group { PDFView(paperBundle.markscheme!.pdf) }
                default:
                    Group { PaperContentsView(paper: paperBundle.questionPaper!, search: $searchText) }
            }
        }
        
        var body: some View {
            NavigationLink(destination: destinationView) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(paperBundle.metadata.subject.rawValue)")
                            .font(.title3)
                            .fontWeight(.black)
                            .padding(6)
                        
                        Text(paperBundle.metadata.questionPaperCode)
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 0.5))
                    }
                    
                    HStack {
                        Text("\(paperBundle.metadata.month.rawValue)")
                            .modifier(TagTextStyle())
                        
                        Text("20\(paperBundle.metadata.year)")
                            .modifier(TagTextStyle())
                        
                        Text("Paper \(paperBundle.metadata.paperNumber.rawValue)")
                            .modifier(TagTextStyle())
                        
                        Text("Variant \(paperBundle.metadata.paperVariant.rawValue)")
                            .modifier(TagTextStyle())
                    }
                    .padding(.leading, 5)
                    
                    if paperBundle.metadata.paperType == .questionPaper {
                        Text("\(paperBundle.metadata.numberOfQuestions) questions  |  \(paperBundle.questionPaper!.pages.count) pages")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(.secondary)
                            .padding(6)
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
