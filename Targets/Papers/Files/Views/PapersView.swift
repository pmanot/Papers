//
// Copyright (c) Purav Manot
//

import SwiftUI
import Filesystem

struct PapersView: View {
    @Binding var pdf: PDFFileDocument
    @State var papers: [QuestionPaper] = []
    
    @State var showPaper: Bool = false
    
    init(_ papers: [QuestionPaper] = [], pdf: Binding<PDFFileDocument>) {
        self.papers = papers
        self._pdf = pdf
    }
    
    var body: some View {
        NavigationView {
            List(papers) { paper in
                Row(paper: paper)
                    .buttonStyle(PlainButtonStyle())
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Papers")
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

extension PapersView {
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
                            Text(paper.metadata.paperCode)
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
            }
        }
    }
}


struct PapersView_Previews: PreviewProvider {
    static var previews: some View {
        PapersView([QuestionPaper.example], pdf: .constant(PDFFileDocument()))
    }
}
