//
// Copyright (c) Purav Manot
//

import PDFKit
import SwiftUI

struct QuestionList: View {
    @State var paper: Paper = Paper.example
    
    init(_ paper: Paper) {
        self.paper = paper
    }
    
    var body: some View {
        List(paper.questions) { question in
            NavigationLink(destination: QuestionView(question)) {
                Text(String(question.index))
            }
        }
    }
}

struct QuestionList_Previews: PreviewProvider {
    static var previews: some View {
        QuestionList(Paper.example)
    }
}
