//
// Copyright (c) Purav Manot
//

import SwiftUIX
import PDFKit
import Filesystem

struct PapersView: View {
    @EnvironmentObject var papersDatabase: PapersDatabase
        
    var body: some View {
        NavigationView {
            ListView()
                .environmentObject(papersDatabase)
        }
    }
}


struct PapersView_Previews: PreviewProvider {
    static var previews: some View {
        PapersView()
            .environmentObject(PapersDatabase())
    }
}

extension PapersView {
    struct ListView: View {
        @EnvironmentObject var database: PapersDatabase
        @State var showImportSheet: Bool = false
        
        var body: some View {
            List(database.papers, id: \.self) { paper in
                Row(paper: paper)
                    .buttonStyle(PlainButtonStyle())
                    .id(UUID())
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Papers")
            .navigationViewStyle(StackNavigationViewStyle())
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
        let paper: CambridgeQuestionPaper
        
        var body: some View {
            NavigationLink(destination: PaperContentsView(paper: paper)) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(paper.metadata.subject.rawValue)")
                            .font(.title3)
                            .fontWeight(.black)
                            .padding(6)
                        
                        Text("\(paper.questions.count) questions")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(6)
                        
                    }
                    
                    HStack {
                        Text("\(paper.metadata.month.rawValue)")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 0.5))
                        
                        Text("20\(paper.metadata.year)")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 0.5))
                        
                        Text("Paper \(paper.metadata.paperNumber.rawValue)")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 0.5))
                        
                        Text("Variant \(paper.metadata.paperVariant.rawValue)")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 0.5))
                    }
                    .padding(.leading, 5)
                    
                }
                .padding(5)
            }
            .contextMenu {
                NavigationLink(destination: PaperContentsView(paper: paper)) {
                    Label(paper.metadata.paperCode, systemImage: "doc.text")
                }
                
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
