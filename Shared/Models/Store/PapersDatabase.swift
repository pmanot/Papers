//
// Copyright (c) Purav Manot
//

import Filesystem
import Foundation
import PDFKit

final public class PapersDatabase: ObservableObject {
    let directory = PaperRelatedDataDirectory()
    
    @Published var calculatedMetadata: [String: CambridgePaperMetadata] = [:]
    @Published var paperBundles: [CambridgePaperBundle] = []
    @Published var newPaperBundles: [NewCambridgePaperBundle] = []
    @Published var solvedPapers: [String: [SolvedPaper]] = [:]
    @Published var questions: [Question] = []
    @Published var deck: [Stack] = []
    
    let calculatingMetadata: Bool = true

    init() {
    }

    func load() {
        // Normal
        
        if calculatingMetadata {
            // While calculating metadata
            let urls = self.directory.findAllPaperURLs()
            //let metadata = try! self.readOrCreateMetadata(paperURLs: urls)
            let metadata = try! self.readOrCreateNewMetadata(paperURLs: urls)
            let paperBundles = self.computeNewPaperBundles(from: urls, metadata: metadata)
            let solvedPapers = try! self.readSolvedPaperData()

            DispatchQueue.main.async {
                self.calculatedMetadata = metadata
                self.paperBundles = paperBundles
                self.solvedPapers = solvedPapers
                self.questions = self.paperBundles.compactMap({ $0.questionPaper }).questions().shuffled()
            }
            
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let urls = self.directory.findAllPaperURLs()
                let paperBundles = self.computePaperBundles(from: urls, metadata: self.readMetadataFromBundle())
                let solvedPapers = try! self.readSolvedPaperData()
                let deck = try! self.readFlashCardDeck()

                DispatchQueue.main.async {
                    self.paperBundles = paperBundles
                    self.solvedPapers = solvedPapers
                    self.deck = deck
                    // self.questions = self.paperBundles.compactMap({ $0.questionPaper }).questions()
                }
            }
        }
    }
    
    /// Erases all existing metadata from disk and erases all stored properties
    func eraseAllData() throws {
        calculatedMetadata = [:]
        paperBundles = []
        questions = []
        
        try directory.deleteAllFiles()
    }
    
    /// Reads existing metadata from disk, or create and write new metadata for the given paper URLs.
    private func readOrCreateNewMetadata(paperURLs: [URL]) throws -> [String: CambridgePaperMetadata] {
        var result: [String: CambridgePaperMetadata]
        if calculatingMetadata {
            print("calculating metadata")
            if let data = directory.read(from: "metadata") {
                // Read the metadata from device
                result = try JSONDecoder().decode([String: CambridgePaperMetadata].self, from: data)
                if result.isEmpty {
                    result = Dictionary(uniqueKeysWithValues: paperURLs.map { ($0.getPaperCode(), CambridgePaperMetadata(url: $0)) })
                }
            } else if let url = Bundle.main.url(forResource: "metadata", withExtension: nil) {
                // Read the metadata from bundle
                let data = try Data(contentsOf: url)
                result = try JSONDecoder().decode([String: CambridgePaperMetadata].self, from: data)
                
                try! self.directory.write(result, toDocumentNamed: "metadata")
            } else {
                result = Dictionary(uniqueKeysWithValues: paperURLs.map { ($0.getPaperCode(), CambridgePaperMetadata(url: $0)) })
            }
        } else {
            let data = try Data(contentsOf: Bundle.main.url(forResource: "metadata", withExtension: nil)!)
            result = try JSONDecoder().decode([String: CambridgePaperMetadata].self, from: data)
            try! self.directory.write(result, toDocumentNamed: "metadata")
        }
        
        if result.isEmpty {
            print("final failsafe")
            result = Dictionary(uniqueKeysWithValues: paperURLs.map { ($0.getPaperCode(), CambridgePaperMetadata(url: $0)) })
        } else {
            print("This is the result \(result)")
        }
        
        return result
    }
    
    private func computeNewPaperBundles(from urls: [URL], metadata: [String : CambridgePaperMetadata]) -> [CambridgePaperBundle] {
        var result: [CambridgePaperBundle] = []

        let standardPaperCodes = urls
            .map { getQuestionPaperCode($0.getPaperCode()) }
            .removingDuplicates()

        let questionPaperURLs = Dictionary(uniqueKeysWithValues: urls.getQuestionPaperURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })
        let markschemeURLs = Dictionary(uniqueKeysWithValues: urls.getMarkschemeURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })
        
        for code in standardPaperCodes {
            let questionPaperURL = questionPaperURLs[code]
            let markSchemeURL = markschemeURLs[code]
            
            print("This please: ", NSHomeDirectory())
            print("\(questionPaperURL!)", "\(markSchemeURL!)")
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
    
    /*
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
            
            print("This please: ", NSHomeDirectory())
            print("\(questionPaperURL!)", "\(markSchemeURL!)")
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
    */
    
    /// OLD
    /// Reads existing metadata from disk, or create and write new metadata for the given paper URLs.
    private func readOrCreateMetadata(paperURLs: [URL]) throws -> [String: CambridgePaperMetadata] {
        // TODO: Account for the fact that `paperURLs` might change.
        var result: [String: CambridgePaperMetadata]
        
        if calculatingMetadata {
            if let data = directory.read(from: "metadata") {
                // Read the metadata
                result = try JSONDecoder().decode([String : CambridgePaperMetadata].self, from: data)
            } else {
                if let metadataURL = Bundle.main.url(forResource: "metadata", withExtension: nil) {
                    let bundleMetadata = try Data(contentsOf: metadataURL)
                    result = try JSONDecoder().decode([String : CambridgePaperMetadata].self, from: bundleMetadata)
                    for url in paperURLs {
                        print("checking metadata...")
                        if result[url.getPaperCode()] == nil {
                            print("adding new paper: \(url.getPaperCode())!")
                            result[url.getPaperCode()] = CambridgePaperMetadata(url: url)
                        } else {
                            print("\(url.getPaperCode()) this one's here!")
                        }
                    }
                    try! self.directory.write(result, toDocumentNamed: "metadata")
                } else {
                    result = [:]

                    // Create the metadata.
                    for url in paperURLs {
                        /// OLD
                        let paperMetadata = CambridgePaperMetadata(url: url)
                        result[paperMetadata.code] = paperMetadata
                        /// ----------------------------------------
                    }
                }
                
                // MARK: - Debugging
                var problemCount: Int = 0
                var successful: Int = 0
                for url in paperURLs {
                    
                    
                    /// OLD
                    if result[url.getPaperCode()]!.paperType == .markScheme {
                        if result[url.getPaperCode()]!.paperNumber == .paper1 {
                            if result[url.getPaperCode()]!.answers == [] {
                                print("MCQ PROBLEM", url.getPaperCode())
                                print("trying to compute again: ")
                                result[url.getPaperCode()] = CambridgePaperMetadata(url: url)
                                if result[url.getPaperCode()]!.answers == [] {
                                    print("ACTUAL PROBLEM", url.getPaperCode())
                                    problemCount += 1
                                } else {
                                    successful += 1
                                }
                            }
                        }
                    }
                    /// ------------------------------------------
                }
                print("problematic: \(problemCount), successful: \(successful)")
                
                // Write the metadata to disk.
                //DispatchQueue.main.async(qos: .userInitiated) {
                try! self.directory.write(result, toDocumentNamed: "metadata")
                print("writing metadata yay!")
                //}
            }
        } else {
            if let url = Bundle.main.url(forResource: "metadata", withExtension: nil){
                let bundleMetadata = try Data(contentsOf: url)
                result = try JSONDecoder().decode([String: CambridgePaperMetadata].self, from: bundleMetadata)
            } else {
                result = [:]
            }
        }
        
        // MARK: Testing

        return result
    }
    /// -----------------------------------------------------------------------------
    
    private func readMetadataFromBundle() -> [String: CambridgePaperMetadata] {
        var result: [String: CambridgePaperMetadata] = [:]
        if let url = Bundle.main.url(forResource: "metadata", withExtension: nil){
            let bundleMetadata = try! Data(contentsOf: url)
            result = try! JSONDecoder().decode([String: CambridgePaperMetadata].self, from: bundleMetadata)
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
            
            print("This please: ", NSHomeDirectory())
            print("\(questionPaperURL!)", "\(markSchemeURL!)")
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
    
    private func readFlashCardDeck() throws -> [Stack] {
        let result: [Stack]
        
        if let data = directory.read(from: "deck") {
            result = try JSONDecoder().decode([Stack].self, from: data)
        } else {
            result = [Stack.example]
            DispatchQueue.main.async {
                try! self.directory.write(result, toDocumentNamed: "deck")
            }
        }
        
        return result
    }
    
    func saveDeck(){
        DispatchQueue.main.async {
            try! self.directory.write(self.deck, toDocumentNamed: "deck")
        }
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
            self.solvedPapers = solvedPapers
        }
    }
}

extension PapersDatabase {
    
    // MARK: - Examples
    var examples: [CambridgePaperMetadata] {
        PaperRelatedDataDirectory().fetchAllAvailablePDFResourceURLs().map { CambridgePaperMetadata(bundleResourceName: $0.getPaperCode()) }
    }
    
    // MARK: - Datasheets
    static var datasheetBySubject: [CambridgeSubject : PDFDocument] = [
        CambridgeSubject.physics : PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_data", ofType: "pdf")!))!,
        CambridgeSubject.chemistry : PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9701_data", ofType: "pdf")!))!
    ]
    
    // MARK: - PaperBundle sort data
    
    static var letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
    static var numerals = ["i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x"]
    static var years: [Int] = [2021, 2020, 2019, 2018, 2017, 2016, 2015]
    static var months: [CambridgePaperMonth] = [.febMarch, .mayJune, .octNov]
    static var subjects: [CambridgeSubject] = [.physics, .chemistry, .biology, .english, .maths]
    static var paperNumbers: [CambridgePaperNumber] = [.paper1, .paper2, .paper3, .paper4, .paper5, .paper6]
    static var paperVariants: [CambridgePaperVariant] = [.variant1, .variant2, .variant3, .variant4, .variant5, .variant6, .variant7, .variant8]
}


