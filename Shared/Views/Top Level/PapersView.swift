//
// Copyright (c) Purav Manot
//

import SwiftUIX
import PDFKit
import Filesystem
import SwiftUI

struct PapersView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    
    @State var searchText: String = ""
    
    var body: some View {
        ListView(papersDatabase: applicationStore.papersDatabase)
            .navigationTitle("Papers")
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationSearchBar {
                SearchBar(text: $searchText)
            }
    }
}


struct PapersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PapersView()
                .environmentObject(ApplicationStore())
                .environmentObject(ApplicationStore().papersDatabase)
        }
    }
}

extension PapersView {
    struct ListView: View {
        @ObservedObject var papersDatabase: PapersDatabase
        @State private var showImportSheet: Bool = false

        var paperBundles: [CambridgePaperBundle] {
            papersDatabase.paperBundles
        }
        
        var body: some View {
            List(paperBundles, id: \.metadata.paperCode){ bundle in
                Row(paperBundle: bundle)
                    .buttonStyle(PlainButtonStyle())
            }
            .listStyle(PlainListStyle())
            .toolbar {
                SymbolButton("plus.circle.fill"){
                    showImportSheet.toggle()
                }
                .font(.body, weight: .bold)
                .foregroundColor(.green)
                .padding()
            }
        }
    }
}


extension PapersView.ListView {
    struct Row: View {
        let paperBundle: CambridgePaperBundle
        
        var body: some View {
            NavigationLink(destination: PaperContentsView(bundle: paperBundle)) {
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

extension PapersView {
    struct BoxView: View {
        var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], content: {
                    ForEach(0..<40){ _ in
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder()
                            .frame(width: 70, height: 70)
                    }
                })
            }
        }
    }
}


enum ViewMode {
    case boxStyle
    case listStyle
}

struct TagTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .font(.caption)
            .opacity(0.8)
            .padding(6)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 0.5))
    }
}