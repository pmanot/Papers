//
// Copyright (c) Purav Manot
//

import Foundation

struct SearchResults {
    
    init(_ papers: [QuestionPaper]){
        self.filteredPapers = papers
        self.filteredQuestionList = papers.questions()
    }
    var filteredPapers: [QuestionPaper] = []
    var filteredQuestionList: [Question] = []
    var filteredMarkschemes: [MarkScheme] = []
    
    mutating func update(_ searchText: String){
        self.filteredQuestionList = filteredPapers.questions()
        self.filteredQuestionList = filteredQuestionList.filter {$0.searchTags.reduce("", +).lowercased().contains(searchText.lowercased())}
    }
}
