//
// Copyright (c) Purav Manot
//

import SwiftUI

struct PaperContentsView: View {
    let paperBundle: CambridgePaperBundle
    @Binding var searchText: String
    
    init(paper: CambridgePaper, search: Binding<String> = Binding.constant("")){
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
                Section(header: "Paper"){
                    PaperRow(paperBundle)
                }
            }
            
            if paperBundle.questionPaper != nil {
                Section(header: "Questions"){
                    ForEach(paperBundle.questionPaper!.questions){ question in
                        NavigationLink(destination: QuestionView(question, bundle: paperBundle)) {
                            QuestionRow(question)
                        }
                        .listRowBackground(!searchText.isEmpty ? Color.primary.opacity(question.rawText.match(searchText) ? 0.4 : 0) : Color.clear)
                    }
                }
            }
        }
        .labelsHidden()
    }
}

/*
struct PaperContentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaperContentsView()
        }
    }
}
*/

extension PaperContentsView {
    struct QuestionRow: View {
        let question: Question
        init(_ question: Question) {
            self.question = question
        }
        
        var body: some View {
            HStack {
                Text("\(self.question.index.index).")
                    .font(.title, weight: .heavy)
                
                Text(
                    question.index.parts
                        .map { $0.displayedIndex() }
                        .joined(separator: ", ")
                )
                    .font(.title2, weight: .heavy)
                    .padding()
                
                Text("\(question.pages.count) pages")
                    .modifier(TagTextStyle())
            }
            .padding()
        }
    }
}

extension PaperContentsView {
    struct PaperRow: View {
        let bundle: CambridgePaperBundle
        
        init(_ paper: CambridgePaper){
            self.bundle = CambridgePaperBundle(questionPaper: paper, markScheme: nil)
        }
        
        init(_ paperBundle: CambridgePaperBundle){
            self.bundle = paperBundle
        }
        
        var body: some View {
            NavigationLink(destination: PDFView(bundle: bundle)) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(bundle.metadata.subject.rawValue)")
                            .font(.title, weight: .black)
                            .padding(6)
                        
                        Text(bundle.metadata.questionPaperCode)
                            .modifier(PaperTagStyle(outlineWidth: 1))
                        
                        if bundle.metadata.paperNumber == .paper1 && bundle.markScheme != nil {
                            if !bundle.markScheme!.metadata.multipleChoiceAnswers.isEmpty {
                                Image(systemName: .checkmarkCircle)
                                    .font(.headline)
                            }
                        }
                    }
                    
                    HStack {
                        Text("\(bundle.metadata.month.compact())")
                            .modifier(PaperTagStyle())
                        
                        Text("\(bundle.metadata.year)")
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

