//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

/// A container for question papers.
///
/// Responsible for loading and containing question papers from the app's documents directory..
final public class PapersDatabase: ObservableObject {
    let directory = DocumentDirectory()
    
    @Published var cambridgePapers: [QuestionPaper] = []
    
    init() {
        
    }
    
    func load() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = self.directory.read(from: "metadata") {
                let papers = try! JSONDecoder().decode([QuestionPaper].self, from: data)
                
                DispatchQueue.main.async {
                    self.cambridgePapers = papers
                }
            } else {
                try! self.directory.write(PapersDatabase.examples, toDocumentNamed: "metadata")
                
                let urls = self.directory.findPapers().map({ Paper(url: $0) })
                
                DispatchQueue.main.async {
                    for url in urls {
                        self.cambridgePapers.append(QuestionPaper(url.url))
                    }
                }
            }
        }
    }
}

// MARK: - Development Preview -

extension PapersDatabase {
    static let examples = [
        QuestionPaper("9701_m20_qp_42"),
        QuestionPaper("9702_w20_qp_22"),
        QuestionPaper("9702_s19_qp_21"),
        QuestionPaper.example2
    ]
}
