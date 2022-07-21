//
// Copyright (c) Purav Manot
//

import SwiftUI

struct SavedCollectionView: View {
    @ObservedObject var papersDatabase: PapersDatabase
    @State private var selectedType: CambridgeSavedItemType = .bundle

    var body: some View {
        VStack {
            Picker("", selection: $selectedType){
                Text("Paper")
                    .tag(CambridgeSavedItemType.bundle)
                Text("Question")
                    .tag(CambridgeSavedItemType.question)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.horizontal, .top])
            
            List {
                switch selectedType {
                    case .bundle:
                        ForEach(papersDatabase.savedPaperCodes, id: \.self) { code in
                            if let bundle = papersDatabase.bundlesByCode[code] {
                                Row(database: papersDatabase, paperBundle: bundle, searchText: nil)
                                    .padding(5)
                                    .swipeActions {
                                        Button(role: .destructive, action: {
                                            papersDatabase.removePaper(code: code)
                                        }, label: {
                                            Label("Remove", systemImage: .xmark)
                                        })
                                    }
                            }
                        }
                    case .question:
                        ForEach(papersDatabase.savedQuestions) { question in
                            VStack(alignment: .leading) {
                                QuestionRow(question)
                                    .swipeActions {
                                        Button(action: {
                                            if !papersDatabase.savedQuestions.contains(question) {
                                                papersDatabase.saveQuestion(question: question)
                                            } else {
                                                papersDatabase.savedQuestions.remove { $0 == question }
                                            }
                                            
                                        }, label: {
                                            if !papersDatabase.savedQuestions.contains(question) {
                                                Label("Save", systemImage: .bookmark)
                                            } else {
                                                Label("Unsave", systemImage: .xmark)
                                            }
                                        })
                                        
                                    }
                                Text(question.rawText)
                                    .frame(height: 100)
                            }
                            .padding(10)
                        }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Saved")
        
    }

    private enum CambridgeSavedItemType: String, Hashable {
        case bundle = "Paper"
        case question = "Question"
    }
}

extension SavedCollectionView {
    struct QuestionRow: View {
        let question: Question
        let searchText: String?
        
        init(_ question: Question, search: String? = nil) {
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
                }
                
                Divider()
                
                if searchText != nil {
                    if question.rawText.match(searchText!) {
                        Text("\"\(question.rawText.getTextAround(string: searchText!))\"")
                            .font(.caption)
                    }
                }
                
            }
        }
    }
}

// MARK: - Development Preview -

struct SavedCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        SavedCollectionView(papersDatabase: ApplicationStore().papersDatabase)
            .environmentObject(ApplicationStore())
    }
}
