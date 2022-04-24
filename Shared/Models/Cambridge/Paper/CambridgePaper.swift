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
    var questions: [Question] {
        if metadata.kind == .longAnswer {
            let indicesArray: [Int] = metadata.indices.map { $0.index }
            var pagesByIndex: [Int : [CambridgePaperPage]] = Dictionary(uniqueKeysWithValues: indicesArray.map { ($0, []) })
                for page in metadata.pages {
                    if !page.questionIndices.isEmpty {
                        pagesByIndex[page.questionIndices.first!.index]!.append(page)
                    }
                }
            if metadata.indices.count != metadata.numberOfQuestions {
                print("Error here:")
                print(metadata.questionPaperCode + " number of indices:" + "\(metadata.indices.count)" + "number of questions: \(metadata.numberOfQuestions)")
                return []
            }
            return indicesArray.map { Question(index: metadata.indices[$0 - 1], pages: pagesByIndex[$0]!, metadata: self.metadata) }
        }
        return []
    }
    
    init(url: URL, metadata: CambridgePaperMetadata) {
        self.url = url
        self.metadata = metadata
    }
}

typealias NewCambridgePaperBundle = (questionPaper: CambridgePaper?, markScheme: CambridgePaper?, datasheet: CambridgePaper?)


extension CambridgePaper {
    var pages: [CambridgePaperPage] {
        metadata.pages
    }
}
