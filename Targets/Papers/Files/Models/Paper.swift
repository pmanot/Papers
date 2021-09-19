//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI
import PDFKit
import Filesystem

// in progress
struct Paper: Hashable, Codable {
    var id = UUID()
    let filename: String
    let url: URL
    
    init(url: URL){
        self.url = url
        self.filename = url.deletingPathExtension().lastPathComponent
    }
    
    func pdf() -> PDFDocument {
        PDFDocument(url: url)!
    }
    
    func filedoc() -> PDFFileDocument {
        PDFFileDocument(pdf: self.pdf())
    }
}

func getCambridgePapers(_ papers: [Paper]) -> [QuestionPaper]{
    var questionPapers: [QuestionPaper] = []
    for paper in papers {
        if paper.filename.contains("_qp") || paper.filename.contains("_ms"){
            questionPapers.append(QuestionPaper(paper.filename))
        }
    }
    return questionPapers
}
