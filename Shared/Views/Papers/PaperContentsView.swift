//
// Copyright (c) Purav Manot
//

import SwiftUI

struct PaperContentsView: View {
    let paper: CambridgeQuestionPaper
    
    init(paper: CambridgeQuestionPaper){
        self.paper = paper
    }
    
    var body: some View {
        List {
            Section(header: "Paper"){
                PaperRow(paper)
            }
            
            Section(header: "Questions"){
                ForEach(paper.questions){ question in
                    QuestionRow(question)
                }
            }
        }
        .onAppear {
            print(fetchPaths())
        }
    }
}

struct PaperContentsView_Previews: PreviewProvider {
    static var previews: some View {
        PaperContentsView(paper: CambridgeQuestionPaper.init(url: PapersDatabase.urls[0], metadata: PapersDatabase().examples[0]))
    }
}

extension PaperContentsView {
    struct QuestionRow: View {
        let question: Question
        init(_ question: Question) {
            self.question = question
        }
        
        var body: some View {
            HStack {
                Text("\(self.question.index.number).")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("\(question.pages.count) pages")
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .opacity(0.8)
                    .padding(6)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 0.5))
            }
            .padding()
        }
    }
}

extension PaperContentsView {
    struct PaperRow: View {
        let paper: CambridgeQuestionPaper
        init(_ paper: CambridgeQuestionPaper){
            self.paper = paper
        }
        
        var body: some View {
            NavigationLink(destination: PDFView(paper.pdf)) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(paper.metadata.subject.rawValue)")
                            .font(.title)
                            .fontWeight(.black)
                            .padding(6)
                        
                        Text(paper.metadata.questionPaperCode)
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.primary)  
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 1))
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
