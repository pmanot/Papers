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
                    PaperRow(paperBundle)
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
        
        init(_ paperBundle: CambridgePaperBundle){
            self.paper = paperBundle
        }
        
        @ViewBuilder var destination: some View {
            switch paper.questionPaper {
                case nil:
                    WrappedPDFView(pdf: paper.markScheme!.pdf)
                default:
                    switch paper.metadata.paperNumber {
                        case .paper1:
                            MCQView(paperBundle: paper)
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
                            .font(.title, weight: .black)
                            .padding(6)
                        
                        Text(paper.metadata.questionPaperCode)
                            .modifier(PaperTagStyle(outlineWidth: 1))
                    }
                    
                    HStack {
                        Text("\(paper.metadata.month.rawValue)")
                            .modifier(PaperTagStyle())
                        
                        Text("20\(paper.metadata.year)")
                            .modifier(PaperTagStyle())
                        
                        Text("Paper \(paper.metadata.paperNumber.rawValue)")
                            .modifier(PaperTagStyle())
                        
                        Text("Variant \(paper.metadata.paperVariant.rawValue)")
                            .modifier(PaperTagStyle())
                    }
                    .padding(.leading, 5)
                    
                }
                .padding(5)
            }
        }
    }
}

struct PaperTagStyle: ViewModifier {
    var outlineWidth: CGFloat = 0.5
    func body(content: Content) -> some View {
        content
            .font(.caption, weight: .regular)
            .foregroundColor(.primary)
            .opacity(0.8)
            .padding(6)
            .border(Color.primary, width: outlineWidth, cornerRadius: 10, style: .circular)
    }
}

