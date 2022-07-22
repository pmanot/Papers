//
// Copyright (c) Purav Manot
//

import Diagnostics
import Filesystem
import SwiftUI
import PDFKit

final public class PapersDatabase: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PapersDatabase")

    let directory = PaperRelatedDataDirectory()
    
    @Published var calculatedMetadata: [String: CambridgePaperMetadata] = [:]
    @Published var bundlesByCode: [String: CambridgePaperBundle] = [:]
    @Published var newPaperBundles: [NewCambridgePaperBundle] = []
    @Published var solvedPapers: [String: [SolvedPaper]] = [:]
    @Published var savedPaperCodes: [String] = []
    @Published var savedQuestions: [Question] = []
    @Published var questions: [Question] = []
    @Published var deck: [Stack] = []
    var paperBundles: [CambridgePaperBundle] {
        [CambridgePaperBundle](bundlesByCode.values)
    }

    let calculatingMetadata: Bool = false

    init() {
        
    }

    func load() {
        // Normal
        
        if calculatingMetadata {
            // While calculating metadata
            let urls = self.directory.findAllPaperURLs()
            //let metadata = try! self.readOrCreateMetadata(paperURLs: urls)
            let metadata = try! self.readOrCreateMetadata(paperURLs: urls)
            let bundlesByCode = self.computeNewPaperBundles(from: urls, metadata: metadata)
            let solvedPapers = try! self.readSolvedPaperData()

            DispatchQueue.main.async {
                self.calculatedMetadata = metadata
                self.bundlesByCode = bundlesByCode
                self.solvedPapers = solvedPapers
            }
            
        } else {
            Task(priority: .userInitiated) {
                let urls = self.directory.findAllPaperURLs()
                let metadata = try! self.readOrCreateMetadata(paperURLs: urls)
                let bundlesByCode = self.computeNewPaperBundles(from: urls, metadata: metadata)
                let solvedPapers = try! self.readSolvedPaperData()
                let deck = try! self.readFlashCardDeck()
                let (savedPaperCodes, savedQuestions) = try! self.readSavedPaperData()

                DispatchQueue.main.async {
                    self.bundlesByCode = bundlesByCode
                    self.solvedPapers = solvedPapers
                    self.deck = deck
                    self.savedPaperCodes = savedPaperCodes
                    self.savedQuestions = savedQuestions
                    // self.questions = self.bundlesByCode.compactMap({ $0.questionPaper }).questions()
                }
            }
        }
    }
    
    /// Erases all existing metadata from disk and erases all stored properties
    func eraseAllData() throws {
        calculatedMetadata = [:]
        bundlesByCode = [:]
        questions = []
        
        try directory.deleteAllFiles()
    }
    
    /// Reads existing metadata from disk, or create and write new metadata for the given paper URLs.
    private func readOrCreateMetadata(paperURLs: [URL]) throws -> [String: CambridgePaperMetadata] {
        
        var result: [String: CambridgePaperMetadata]
        
        if calculatingMetadata {
            if let data = directory.read(from: "metadata") {
                // Read the metadata from device
                result = try JSONDecoder().decode([String : CambridgePaperMetadata].self, from: data)
            } else {
                // Cannot read metadata from device
                if let url = Bundle.main.url(forResource: "metadata", withExtension: nil) {
                    // Try reading metadata from bundle
                    result = try JSONDecoder().decode([String : CambridgePaperMetadata].self, from: Data(contentsOf: url))
                    
                    for url in paperURLs {
                        // Check if metadata is complete
                        if result[url.getPaperCode()].isNil {
                            // Calculate the metadata for a new paper
                            result[url.getPaperCode()] = CambridgePaperMetadata(url: url)
                        }
                    }
                    // Write the metadata to device
                    try! self.directory.write(result, toDocumentNamed: "metadata")
                } else {
                    // Create the metadata.
                    result = Dictionary(uniqueKeysWithValues: paperURLs.map { ($0.getPaperCode(), CambridgePaperMetadata(url: $0)) })
                    // Write the metadata to device
                    try! self.directory.write(result, toDocumentNamed: "metadata")
                }
                
            }
        } else {
            if let url = Bundle.main.url(forResource: "metadata", withExtension: nil) {
                // Try reading the metadata from bundle
                result = try JSONDecoder().decode([String : CambridgePaperMetadata].self, from: Data(contentsOf: url))
            } else {
                result = [:]
            }
        }
        return result
    }
    
    private func computeNewPaperBundles(from urls: [URL], metadata: [String : CambridgePaperMetadata]) -> [String : CambridgePaperBundle] {
        var result: [String: CambridgePaperBundle] = [:]

        let standardPaperCodes = urls
            .map { getQuestionPaperCode($0.getPaperCode()) }
            .removingDuplicates()

        let questionPaperURLs = Dictionary(uniqueKeysWithValues: urls.getQuestionPaperURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })
        let markschemeURLs = Dictionary(uniqueKeysWithValues: urls.getMarkschemeURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })
        
        for code in standardPaperCodes {
            let questionPaperURL = questionPaperURLs[code]
            let markSchemeURL = markschemeURLs[code]
            
            logger.debug("Processing question paper URL: \(questionPaperURL!), mark scheme URL: \(markSchemeURL!)")
            
            result[code] = (
                CambridgePaperBundle(
                    questionPaper: questionPaperURL.map {
                        CambridgePaper(
                            url: $0,
                            metadata: metadata[$0.getPaperCode()]!
                        )
                    },
                    markScheme: markSchemeURL.map {
                        CambridgePaper(
                            url: $0,
                            metadata: metadata[$0.getPaperCode()]!
                        )
                    }
                )
            )
        }
        
        return result
    }
    
    /// Creates paper bundles from the given paper URLs.
    private func computePaperBundles(from urls: [URL], metadata: [String : CambridgePaperMetadata]) -> [String: CambridgePaperBundle] {
        var result: [String : CambridgePaperBundle] = [:]

        let standardPaperCodes = urls
            .map { getQuestionPaperCode($0.getPaperCode()) }
            .removingDuplicates()

        let questionPaperURLs = Dictionary(uniqueKeysWithValues: urls.getQuestionPaperURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })
        let markschemeURLs = Dictionary(uniqueKeysWithValues: urls.getMarkschemeURLs().map { (getQuestionPaperCode($0.getPaperCode()), $0) })

        for code in standardPaperCodes {
            let questionPaperURL = questionPaperURLs[code]
            let markSchemeURL = markschemeURLs[code]
            
            logger.debug("Processing question paper URL: \(questionPaperURL!), mark scheme URL: \(markSchemeURL!)")
            
            result[code] = (
                CambridgePaperBundle(
                    questionPaper: questionPaperURL.map {
                        CambridgePaper(
                            url: $0,
                            metadata: metadata[$0.getPaperCode()]!
                        )
                    },
                    markScheme: markSchemeURL.map {
                        CambridgePaper(
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
    
    private func readSavedPaperData() throws -> ([String], [Question]){
        let paperCodes: [String]
        let questions: [Question]
        if let data = directory.read(from: "savedPapers") {
            paperCodes = try JSONDecoder().decode([String].self, from: data)
        } else {
            paperCodes = []
            DispatchQueue.main.async {
                try! self.directory.write(paperCodes, toDocumentNamed: "savedPapers")
            }
        }
        if let data = directory.read(from: "savedQuestions") {
            questions = try JSONDecoder().decode([Question].self, from: data)
        } else {
            questions = []
            DispatchQueue.main.async {
                try! self.directory.write(questions, toDocumentNamed: "savedQuestions")
            }
        }
        
        return (paperCodes, questions)
    }
    
    func saveDeck(){
        DispatchQueue.main.async {
            try! self.directory.write(self.deck, toDocumentNamed: "deck")
        }
    }
    
    
    // MARK: - Save and Remove Papers
    
    func savePaper(bundle: CambridgePaperBundle) {
        self.savedPaperCodes.append(bundle.questionPaperCode)
        DispatchQueue.main.async {
            try! self.directory.write(self.savedPaperCodes, toDocumentNamed: "savedPapers")
        }
    }
    
    func savePaper(code: String) {
        self.savedPaperCodes.append(code)
        DispatchQueue.main.async {
            try! self.directory.write(self.savedPaperCodes, toDocumentNamed: "savedPapers")
        }
    }
    
    func removePaper(bundle: CambridgePaperBundle){
        self.savedPaperCodes.remove({ $0 == bundle.questionPaperCode })
        DispatchQueue.main.async {
            try! self.directory.write(self.savedPaperCodes, toDocumentNamed: "savedPapers")
        }
    }
    
    func removePaper(code: String){
        self.savedPaperCodes.remove { $0 == code }
        DispatchQueue.main.async {
            try! self.directory.write(self.savedPaperCodes, toDocumentNamed: "savedPapers")
        }
    }
    
    func saveQuestion(question: Question){
        self.savedQuestions.append(question)
        DispatchQueue.main.async {
            try! self.directory.write(self.savedQuestions, toDocumentNamed: "savedQuestions")
        }
    }
    
    func removeQuestion(question: Question){
        self.savedQuestions.remove { $0 == question }
        DispatchQueue.main.async {
            try! self.directory.write(self.savedQuestions, toDocumentNamed: "savedQuestions")
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
    
    static var letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n"]
    static var numerals = ["i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x"]
    static var years: [Int] = [2021, 2020, 2019, 2018, 2017, 2016, 2015]
    static var months: [CambridgePaperMonth] = [.febMarch, .mayJune, .octNov]
    static var subjects: [CambridgeSubject] = [.physics, .chemistry, .biology, .english, .maths]
    static var paperNumbers: [CambridgePaperNumber] = [.paper1, .paper2, .paper3, .paper4, .paper5, .paper6]
    static var paperVariants: [CambridgePaperVariant] = [.variant1, .variant2, .variant3, .variant4, .variant5, .variant6, .variant7, .variant8]
}


