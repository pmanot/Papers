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
    
    @State var paperBundles: [CambridgePaperBundle] = []
    
    var body: some View {
        ListView(paperBundles: $paperBundles, searchText: $searchText)
            .navigationTitle("Search")
            .listStyle(GroupedListStyle())
            .onChange(of: searchText){ _ in
                DispatchQueue.global(qos: .userInitiated).async {
                    paperBundles = applicationStore.papersDatabase.paperBundles.filter({ paperBundle in
                        paperBundle.metadata.rawText.match(searchText)
                    })
                }
            }
    }
}

extension SearchView {
    struct ListView: View {
        @Binding var paperBundles: [CambridgePaperBundle]
        @Binding var searchText: String
        @State var selection: Int = 0
        
        var body: some View {
            List(paperBundles, id: \.metadata.code){ bundle in
                Row(searchText: $searchText, paperBundle: bundle)
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
}


extension SearchView.ListView {
    struct Row: View {
        @Binding var searchText: String
        let paperBundle: CambridgePaperBundle
        
        var body: some View {
            NavigationLink(destination: PaperContentsView(bundle: paperBundle, search: searchText)) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\"\(searchText)\"")
                            .font(.title3, weight: .bold)
                        Text(paperBundle.metadata.subject.rawValue)
                            .modifier(TagTextStyle())
                    }
                    HStack {
                        Text("\(paperBundle.metadata.month.compact())")
                            .modifier(TagTextStyle())
                        
                        Text(String(paperBundle.metadata.year))
                            .modifier(TagTextStyle())
                        
                        Text("Paper \(paperBundle.metadata.paperNumber.rawValue)")
                            .modifier(TagTextStyle())
                        
                        Text("Variant \(paperBundle.metadata.paperVariant.rawValue)")
                            .modifier(TagTextStyle())
                    }
                }
                .padding(5)
                
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Development Preview -

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
                .environmentObject(ApplicationStore())
        }
    }
}
