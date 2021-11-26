//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

final public class PapersDatabase: ObservableObject {
    let directory = DocumentDirectory()
    
    @Published var metadata: [String : CambridgePaperMetadata] = [:]
    @Published var papers: [CambridgeQuestionPaper] = []
    @Published var paperBundles: [CambridgePaperBundle] = []
    @Published var questions: [Question] = []
    init() {
        
    }
    
    func load() {
        var urls = self.directory.findPapers()
        DispatchQueue.global(qos: .userInitiated).async {
            if urls == [] {
                for url in fetchPaths() {
                    self.directory.writePDF(pdf: PDFDocument(url: url)!, to: url.getPaperCode())
                }
            }
            urls = self.directory.findPapers()
            print(urls)
            
            if let data = self.directory.read(from: "metadata"){ // metadata file present
                let fetchedMetadata = try! JSONDecoder().decode([String: CambridgePaperMetadata].self, from: data)
                
                DispatchQueue.main.async { [self] in
                    self.metadata = fetchedMetadata
                    print(fetchedMetadata.values)
                    let standardPaperCodes = urls.map { getQuestionPaperCode($0.getPaperCode()) }.removingDuplicates()
                     
                    let questionPaperURLs = Dictionary(uniqueKeysWithValues: urls.getQuestionPaperURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })
                    let markschemeURLs = Dictionary(uniqueKeysWithValues: urls.getMarkschemeURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })
                    
                    for code in standardPaperCodes {
                        let qp = questionPaperURLs[code]
                        let ms = markschemeURLs[code]
                        print("keys: ", metadata.keys)
                        if qp != nil && ms != nil {
                            self.paperBundles.append(CambridgePaperBundle(questionPaper: CambridgeQuestionPaper(url: qp!, metadata: metadata[qp!.getPaperCode()]!), markscheme: CambridgeMarkscheme(url: ms!, metadata: metadata[ms!.getPaperCode()]!)))
                        } else if qp != nil {
                            self.paperBundles.append(CambridgePaperBundle(questionPaper: CambridgeQuestionPaper(url: qp!, metadata: metadata[qp!.getPaperCode()]!), markscheme: nil))
                        } else if ms != nil {
                            self.paperBundles.append(CambridgePaperBundle(questionPaper: nil, markscheme: CambridgeMarkscheme(url: ms!, metadata: metadata[ms!.getPaperCode()]!)))
                        }
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    for url in urls {
                        let paperMetadata = CambridgePaperMetadata(url: url)
                        self.metadata[paperMetadata.paperCode] = paperMetadata
                    }
                    try! self.directory.write(self.metadata, toDocumentNamed: "metadata")
                }
                print("written: ", self.metadata.mapValues {$0.paperCode})
                print("metadata written")
            }
        }
        self.questions = self.paperBundles.compactMap { $0.questionPaper }.questions()
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
    static let exampleMCQ = PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_qp_11", ofType: ".pdf")!))
}

extension URL {
    func getPaperCode() -> String {
        self.deletingPathExtension().lastPathComponent
    }
}

func fetchPaths() -> [URL] {
    Bundle.main.urls(forResourcesWithExtension: "pdf", subdirectory: "/") ?? []
}


