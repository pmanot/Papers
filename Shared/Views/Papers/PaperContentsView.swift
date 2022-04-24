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
                            QuestionRow(question, search: searchText)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(!searchText.isEmpty ? Color.accentColor.opacity(question.rawText.match(searchText) ? 0.4 : 0) : Color.clear)
                    }
                }
            }
        }
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
        let searchText: String
        
        init(_ question: Question, search: String) {
            self.question = question
            self.searchText = search
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(self.question.index.index).")
                        .font(.title, weight: .heavy)
                    
                    Spacer()
                    
                    Text("\(question.index.parts.count) parts")
                        .modifier(TagTextStyle())
                    
                    Text("\(question.pages.count) pages")
                        .modifier(TagTextStyle())
                }
                if question.rawText.match(searchText) {
                    Text("\"\(question.rawText.getTextAround(string: searchText))\"")
                        .font(.caption)
                }
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
                            .font(.title, weight: .bold)
                            .padding(6)
                        
                        
                        
                        if bundle.metadata.paperNumber == .paper1 && bundle.markScheme != nil {
                            if !bundle.markScheme!.metadata.multipleChoiceAnswers.isEmpty {
                                Image(systemName: .checkmarkCircleFill)
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    HStack {
                        Text(bundle.metadata.questionPaperCode)
                            .modifier(TagTextStyle())
                        
                        Text("\(bundle.metadata.pages.count) pages")
                            .modifier(TagTextStyle())
                        
                        Text("\(bundle.metadata.numberOfQuestions) questions")
                            .modifier(TagTextStyle())
                    }
                    .padding(.leading, 5)
                    
                    
                    
                }
                .padding(5)
            }
        }
    }
}

