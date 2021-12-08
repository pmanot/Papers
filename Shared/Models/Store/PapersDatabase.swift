//
// Copyright (c) Purav Manot
//

import Filesystem
import Foundation
import PDFKit

final public class PapersDatabase: ObservableObject {
    let directory = PaperRelatedDataDirectory()
    
    @Published var metadata: [String: CambridgePaperMetadata] = [:]
    @Published var paperBundles: [CambridgePaperBundle] = []
    @Published var solvedPapers: [String: [SolvedPaper]] = [:]
    @Published var questions: [Question] = []

    init() {
    }

    func load() {
        DispatchQueue.global(qos: .userInitiated).async {
            let urls = self.directory.findAllPaperURLs()

            let metadata = try! self.readOrCreateMetadata(paperURLs: urls)
            let paperBundles = self.computePaperBundles(from: urls, metadata: metadata)
            let solvedPapers = try! self.readSolvedPaperData()

            DispatchQueue.main.async {
                self.metadata = metadata
                self.paperBundles = paperBundles
                self.solvedPapers = solvedPapers
                self.questions = self.paperBundles.compactMap({ $0.questionPaper }).questions()
            }
        }
    }
    
    /// Erases all existing metadata from disk and erases all stored properties
    func eraseAllData() throws {
        metadata = [:]
        paperBundles = []
        questions = []
        
        try directory.deleteAllFiles()
    }

    /// Reads existing metadata from disk, or create and write new metadata for the given paper URLs.
    private func readOrCreateMetadata(paperURLs: [URL]) throws -> [String: CambridgePaperMetadata] {
        // TODO: Account for the fact that `paperURLs` might change.

        var result: [String: CambridgePaperMetadata]

        if let data = directory.read(from: "metadata") {
            result = try JSONDecoder().decode([String : CambridgePaperMetadata].self, from: data)
        } else {
            result = [:]

            // Create the metadata.
            for url in paperURLs {
                let paperMetadata = CambridgePaperMetadata(url: url)

                result[paperMetadata.paperCode] = paperMetadata
            }

            // Write the metadata to disk.
            DispatchQueue.main.async(qos: .userInitiated) {
                try! self.directory.write(result, toDocumentNamed: "metadata")
            }
        }

        return result
    }

    /// Creates paper bundles from the given paper URLs.
    private func computePaperBundles(from urls: [URL], metadata: [String : CambridgePaperMetadata]) -> [CambridgePaperBundle] {
        var result: [CambridgePaperBundle] = []

        let standardPaperCodes = urls
            .map { getQuestionPaperCode($0.getPaperCode()) }
            .removingDuplicates()

        let questionPaperURLs = Dictionary(uniqueKeysWithValues: urls.getQuestionPaperURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })
        let markschemeURLs = Dictionary(uniqueKeysWithValues: urls.getMarkschemeURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })

        for code in standardPaperCodes {
            let questionPaperURL = questionPaperURLs[code]
            let markSchemeURL = markschemeURLs[code]

            result.append(
                CambridgePaperBundle(
                    questionPaper: questionPaperURL.map {
                        CambridgeQuestionPaper(
                            url: $0,
                            metadata: metadata[$0.getPaperCode()]!
                        )
                    },
                    markScheme: markSchemeURL.map {
                        CambridgeMarkscheme(
                            url: $0,
                            metadata: metadata[$0.getPaperCode()]!
                        )
                    }
                )
            )
        }

        return result
    }
    
    private func readSolvedPaperData() throws -> [String : [SolvedPaper]] {
        let result: [String : [SolvedPaper]]
        
        if let data = directory.read(from: "solvedPaperData") {
            result = try JSONDecoder().decode([String : [SolvedPaper]].self, from: data)
        } else {
            result = [:]
        }
        
        return result
    }
    
    func writeSolvedPaperData(_ solved: SolvedPaper) {
        let key = solved.paperCode
        var solvedPapers = try! readSolvedPaperData()
        if solvedPapers[key].isNilOrEmpty {
            solvedPapers[key] = [solved]
        } else {
            solvedPapers[key]!.append(solved)
        }
        
        DispatchQueue.main.async(qos: .userInitiated){
            try! self.directory.write(solvedPapers, toDocumentNamed: "solvedPaperData")
        }
    }
}

extension PapersDatabase {
    var examples: [CambridgePaperMetadata] {
        PaperRelatedDataDirectory().fetchAllAvailablePDFResourceURLs().map { CambridgePaperMetadata(bundleResourceName: $0.getPaperCode()) }
    }
    
    static let urls: [URL] = ["9702_s18_qp_21", "9702_w20_qp_22", "9702_s19_qp_21", "9701_m20_qp_42"]
        .map {
            URL(fileURLWithPath: Bundle.main.path(forResource: $0, ofType: "pdf")!)
        }
    static let exampleMCQ = CambridgeQuestionPaper(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_qp_11", ofType: ".pdf")!), metadata: CambridgePaperMetadata(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_qp_11", ofType: ".pdf")!)))
    static let exampleMCQms = CambridgeMarkscheme(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_ms_11", ofType: ".pdf")!), metadata: CambridgePaperMetadata(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_ms_11", ofType: ".pdf")!)))
    
    static let MCQBundle = CambridgePaperBundle(questionPaper: exampleMCQ, markScheme: exampleMCQms)
}

extension URL {
    func getPaperCode() -> String {
        self.deletingPathExtension().lastPathComponent
    }
}
