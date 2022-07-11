//
// Copyright (c) Purav Manot
//

import SwiftUI

struct PaperContentsView: View {
    @ObservedObject var database: PapersDatabase
    let paperBundle: CambridgePaperBundle
    let searchText: String?
    
    init(paper: CambridgePaper, search: String? = nil, database: PapersDatabase){
        self.paperBundle = CambridgePaperBundle(questionPaper: paper, markScheme: nil)
        self.searchText = search
        self.database = database
    }
    
    init(bundle: CambridgePaperBundle, search: String? = nil, database: PapersDatabase){
        self.paperBundle = bundle
        self.searchText = search
        self.database = database
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
                            QuestionRow(database: database, question, search: searchText)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .swipeActions {
                            Button(action: {
                                if !database.savedQuestions.contains(question) {
                                    database.saveQuestion(question: question)
                                } else {
                                    database.savedQuestions.remove { $0 == question }
                                }
                                
                            }, label: {
                                if !database.savedQuestions.contains(question) {
                                    Label("Save", systemImage: .bookmark)
                                } else {
                                    Label("Unsave", systemImage: .xmark)
                                }
                            })
                            
                        }
                        .listRowBackground(!searchText.isNilOrEmpty ? Color.accentColor.opacity(question.rawText.match(searchText!) ? 0.4 : 0) : Color.clear)
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
        @ObservedObject var database: PapersDatabase
        let question: Question
        let searchText: String?
        
        init(database: PapersDatabase, _ question: Question, search: String? = nil) {
            self.database = database
            self.question = question
            self.searchText = search
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(self.question.index.index).")
                        .font(.title, weight: .heavy)
                        .padding(.horizontal)
                    
                    Text("\(question.index.parts.count) parts")
                        .modifier(TagTextStyle())
                    
                    Text("\(question.pages.count) pages")
                        .modifier(TagTextStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        if !database.savedQuestions.contains(question) {
                            database.saveQuestion(question: question)
                        } else {
                            database.removeQuestion(question: question)
                        }
                        
                    }){
                        Image(systemName: database.savedQuestions.contains(question) ? .bookmarkFill : .bookmark)
                    }
                }
                if searchText != nil {
                    if question.rawText.match(searchText!) {
                        Text("\"\(question.rawText.getTextAround(string: searchText!))\"")
                            .font(.caption)
                    }
                }
            }
            .padding(.vertical, 10)
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

