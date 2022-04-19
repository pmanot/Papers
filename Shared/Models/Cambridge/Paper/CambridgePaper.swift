//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct CambridgePaper: Hashable {
    var url: URL
    var pdf: PDFDocument {
        PDFDocument(url: url)!
    }
    var metadata: CambridgePaperMetadata
}

typealias NewCambridgePaperBundle = (questionPaper: CambridgePaper?, markScheme: CambridgePaper?, datasheet: CambridgePaper?)


extension CambridgePaper {
    var pages: [CambridgePaperPage] {
        metadata.pages
    }
    
    var questions: [Question] {
        var final: [Question] = []
        if metadata.kind == .longAnswer {
            var question: Question
            for i in 1...metadata.numberOfQuestions {
                print("i = \(i)")
                let pages = pages.filter { $0.questionIndices.map { $0.index }.contains(i) }
                for page in pages {
                    print("Page \(page.index)")
                    print(page.questionIndices.map { $0.displayedIndex() })
                    print(page.questionIndices.map { $0.parts }.reduce([], +).map { $0.displayedIndex() })
                    print(page.questionIndices.map { $0.parts }.reduce([], +).map { $0.parts }.reduce([], +).map { $0.displayedIndex() })
                    print("------")
                }
                let index = QuestionIndex(pages.map { $0.questionIndices }.reduce([], +))
                question = Question(index: index, pages: pages, metadata: metadata)
                if question.pages != [] {
                    final.append(question)
                } else {
                    break
                }
            }
            if final.count != metadata.numberOfQuestions {
                print("Error! Now we got a problem bitch.")
                print(pages)
            }
        }
        return final
    }
}
