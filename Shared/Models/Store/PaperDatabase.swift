//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

final public class PapersDatabase: ObservableObject {
    let directory = DocumentDirectory()
    
    @Published var metadata: [CambridgePaperMetadata] = []
    @Published var papers: [CambridgeQuestionPaper] = []
    @Published var paperBundles: [CambridgePaperBundle] = []
    var questions: [Question] {
        paperBundles.compactMap { $0.questionPaper }.questions()
    }
    init() {
        
    }
    
    func load() {
        var urls = self.directory.findPapers()
        var paperCodes: [String] = []
        DispatchQueue.global(qos: .userInitiated).async {
            if urls == [] {
                for url in fetchPaths() {
                    self.directory.writePDF(pdf: PDFDocument(url: url)!, to: url.getPaperCode())
                }
            }
            urls = self.directory.findPapers()
            
            if let data = self.directory.read(from: "metadata") {
                let fetchedMetadata = try! JSONDecoder().decode([CambridgePaperMetadata].self, from: data)
                
                DispatchQueue.main.async {
                    self.metadata = fetchedMetadata
                    paperCodes = urls.map { getQuestionPaperCode($0.getPaperCode()) }.removingDuplicates()
                    print(paperCodes)
                    for paperCode in paperCodes {
                        let questionPaperByCode = urls.first (where: { getQuestionPaperCode($0.getPaperCode()) == paperCode }).map{ CambridgeQuestionPaper(url: $0, metadata: fetchedMetadata.first { getQuestionPaperCode($0.paperCode) == paperCode }!)} ?? nil
                        let markschemeByCode = urls.first (where: { getQuestionPaperCode($0.getPaperCode()) == paperCode }).map { CambridgeMarkscheme(url: $0, metadata: fetchedMetadata.first { getQuestionPaperCode($0.paperCode) == paperCode }!)} ?? nil
                        self.paperBundles.append(CambridgePaperBundle(questionPaper: questionPaperByCode, markscheme: markschemeByCode))
                        
                    }
                }
                
            } else {
                try! self.directory.write(PapersDatabase().examples, toDocumentNamed: "metadata")
                print("metadata written")
                DispatchQueue.main.async {
                    for url in urls {
                        let paperMetadata = CambridgePaperMetadata(url: url)
                        self.metadata.append(paperMetadata)
                        self.papers.append(
                            CambridgeQuestionPaper(url: url, metadata: paperMetadata)
                        )
                    }
                }
            }
        }
    }
}


extension PapersDatabase {
    var examples: [CambridgePaperMetadata] {
        fetchPaths().map { CambridgePaperMetadata(bundleResourceName: $0.getPaperCode()) }
    }
    
    static let urls: [URL] = ["9702_s18_qp_21", "9702_w20_qp_22", "9702_s19_qp_21", "9701_m20_qp_42"]
        .map {
            URL(fileURLWithPath: Bundle.main.path(forResource: $0, ofType: "pdf")!)
        }
}

extension URL {
    func getPaperCode() -> String {
        self.deletingPathExtension().lastPathComponent
    }
}

func fetchPaths() -> [URL] {
    Bundle.main.urls(forResourcesWithExtension: "pdf", subdirectory: "/") ?? []
}
