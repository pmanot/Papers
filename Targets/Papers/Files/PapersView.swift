//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit
import Filesystem

struct PapersView: View {
    @EnvironmentObject var papers: Papers
    @State var viewingMode: ViewMode = .listStyle
    
    var body: some View {
            SearchView()
                .environmentObject(papers)
        .onAppear {
            papers.load()
        }
    }
}


struct PapersView_Previews: PreviewProvider {
    static var previews: some View {
        PapersView()
            .environmentObject(Papers())
    }
}

extension PapersView {
    struct ListView: View {
        @EnvironmentObject var papers: Papers
        @State var showImportSheet: Bool = false
        
        var body: some View {
            List(papers.cambridgePapers, id: \.self){ paper in
                Section {
                    
                }
                Row(paper: paper)
                    .buttonStyle(PlainButtonStyle())
                    .id(UUID())
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Papers")
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                ButtonSymbol("plus.circle.fill"){
                    showImportSheet.toggle()
                }
                .font(.largeTitle, weight: .bold)
                .foregroundColor(.green)
                .padding()
            }
            .fileImporter(isPresented: $showImportSheet, allowedContentTypes: [.pdf, .folder]){ result in
                switch result {
                case .success(let url):
                    if url.startAccessingSecurityScopedResource() {
                        var newPapers = papers.cambridgePapers
                        newPapers.append(QuestionPaper(url))
                        print(newPapers)
                        print(url)
                        try! DocumentDirectory().write(newPapers, toDocumentNamed: "metadata")
                        DocumentDirectory().writePDF(pdf: PDFDocument(url: url)!, to: Paper(url: url).filename)
                        url.stopAccessingSecurityScopedResource()
                    }
                case .failure(let error):
                    print("Oops, \(error.localizedDescription)")
                }
                papers.load()
            }
        }
    }
}


extension PapersView.ListView {
    struct Row: View {
        let paper: QuestionPaper
        
        var body: some View {
            NavigationLink(destination: QuestionList(paper)) {
                HStack(alignment: .bottom) {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(paper.metadata.subject.rawValue)
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                Text(String(paper.metadata.year))
                                    .font(.body)
                            }
                            Text(paper.metadata.paperCode.id)
                                .font(.caption2)
                                .fontWeight(.light)
                                .padding(.leading, 2)
                        }
                        .frame(width: 245, alignment: .leading)
                        
                        Text(String(paper.questions.count))
                            .foregroundColor(.primary)
                            .colorInvert()
                            .font(.callout)
                            .frame(width: 35, height: 35)
                            .background(Color.primary.cornerRadius(10))
                    }
                    .padding(.vertical, 7)
                }
                .padding(5)
                .contextMenu(ContextMenu(menuItems: {
                    Text("one")
                    Text("Menu Item 2")
                    Text("\(paper.questions.toJSONString()!)")
                }))
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
