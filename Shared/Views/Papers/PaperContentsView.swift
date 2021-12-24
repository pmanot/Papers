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
        let bundle: CambridgePaperBundle
        
        init(_ paper: CambridgeQuestionPaper){
            self.bundle = CambridgePaperBundle(questionPaper: paper, markScheme: nil)
        }
        
        init(_ paper: CambridgeMarkscheme){
            self.bundle = CambridgePaperBundle(questionPaper: nil, markScheme: paper)
        }
        
        init(_ paperBundle: CambridgePaperBundle){
            self.bundle = paperBundle
        }
        
        @ViewBuilder var destination: some View {
            switch bundle.questionPaper {
                case nil:
                    // Using WrappedPDFView
                    WrappedPDFView(pdf: bundle.markScheme!.pdf)
                default:
                    switch bundle.metadata.paperNumber {
                        case .paper1: // MCQ
                            MCQView(paperBundle: bundle)
                        default:
                            // Using WrappedPDFView
                            WrappedPDFView(pdf: bundle.questionPaper!.pdf)
                            
                            // Using QuickLook
                            /*
                            QuickLook(url: paper.questionPaper!.getPaperURL())
                            */
                    }
            }
        }
        
        var body: some View {
            NavigationLink(destination: destination) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(bundle.metadata.subject.rawValue)")
                            .font(.title, weight: .black)
                            .padding(6)
                        
                        Text(bundle.metadata.questionPaperCode)
                            .modifier(PaperTagStyle(outlineWidth: 1))
                    }
                    
                    HStack {
                        Text("\(bundle.metadata.month.rawValue)")
                            .modifier(PaperTagStyle())
                        
                        Text("20\(bundle.metadata.year)")
                            .modifier(PaperTagStyle())
                        
                        Text("Paper \(bundle.metadata.paperNumber.rawValue)")
                            .modifier(PaperTagStyle())
                        
                        Text("Variant \(bundle.metadata.paperVariant.rawValue)")
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

