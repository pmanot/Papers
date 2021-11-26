//
// Copyright (c) Purav Manot
//

import SwiftUI

struct PaperContentsView: View {
    let paperBundle: CambridgePaperBundle
    @Binding var searchText: String
    
    init(paper: CambridgeQuestionPaper, search: Binding<String> = Binding.constant("")){
        self.paperBundle = CambridgePaperBundle(questionPaper: paper, markScheme: nil)
        self._searchText = search
    }
    
    init(bundle: CambridgePaperBundle, search: Binding<String> = Binding.constant("")){
        self.paperBundle = bundle
        self._searchText = search
    }
    
    var body: some View {
        List {
            if paperBundle.questionPaper != nil {
                Section(header: "Question Paper"){
                    PaperRow(paperBundle.questionPaper!)
                }
            }
            
            if paperBundle.markScheme != nil {
                Section(header: "Markscheme"){
                    PaperRow(paperBundle.markScheme!)
                }
            }
            
            if paperBundle.questionPaper != nil {
                Section(header: "Questions"){
                    ForEach(paperBundle.questionPaper!.questions){ question in
                        NavigationLink(destination: QuestionView(question)) {
                            QuestionRow(question)
                        }
                        .listRowBackground(!searchText.isEmpty ? Color.white.opacity(question.rawText.match(searchText) ? 0.4 : 0) : Color.clear)
                    }
                }
            }
        }
        .labelsHidden()
    }
}

struct PaperContentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaperContentsView(paper: CambridgeQuestionPaper(url: PapersDatabase.urls[0], metadata: ApplicationStore().papersDatabase.examples[0]))
        }
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
        let paper: CambridgePaperBundle
        init(_ paper: CambridgeQuestionPaper){
            self.paper = CambridgePaperBundle(questionPaper: paper, markScheme: nil)
        }
        
        init(_ paper: CambridgeMarkscheme){
            self.paper = CambridgePaperBundle(questionPaper: nil, markScheme: paper)
        }
        
        @ViewBuilder var destination: some View {
            switch paper.questionPaper {
                case nil:
                    WrappedPDFView(pdf: paper.markScheme!.pdf)
                default:
                    switch paper.metadata.paperNumber {
                        case .paper1:
                            MCQView(paper: CambridgeMultipleChoicePaper(url: paper.questionPaper!.pdf.documentURL!, metadata: paper.metadata))
                        default:
                            WrappedPDFView(pdf: paper.questionPaper!.pdf)
                    }
            }
        }
        
        var body: some View {
            NavigationLink(destination: destination) {
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
                            .border(Color.primary, width: 1, cornerRadius: 10, style: .circular)
                    }
                    
                    HStack {
                        Text("\(paper.metadata.month.rawValue)")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(6)
                            .border(Color.primary, width: 0.5, cornerRadius: 10, style: .circular)
                        
                        Text("20\(paper.metadata.year)")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(6)
                            .border(Color.primary, width: 0.5, cornerRadius: 10, style: .circular)
                        
                        Text("Paper \(paper.metadata.paperNumber.rawValue)")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(6)
                            .border(Color.primary, width: 0.5, cornerRadius: 10, style: .circular)
                        
                        Text("Variant \(paper.metadata.paperVariant.rawValue)")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(6)
                            .border(Color.primary, width: 0.5, cornerRadius: 10, style: .circular)
                    }
                    .padding(.leading, 5)
                    
                }
                .padding(5)
            }
        }
    }
}
