//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

/// Represents the paper-related data directory within the app's documents directory.
struct PaperRelatedDataDirectory {
    var url: URL { try!
        manager
            .url(
                for: .documentDirectory,
                   in: .userDomainMask,
                   appropriateFor: nil,
                   create: false
            )
            .appendingPathComponent("Paper Directory")
    }
    var manager = FileManager.default

    // MARK: - Reading

    func read(from filename: String) -> Data? {
        do {
            let nestedFolderURL = url

            if !manager.fileExists(atPath: nestedFolderURL.relativePath) {
                try manager.createDirectory(
                    at: nestedFolderURL,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
            }
            let fileURL = nestedFolderURL.appendingPathComponent(filename)

            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("Read Error: ", error.localizedDescription)
            return nil
        }
    }

    // MARK: - Writing

    func write<T: Encodable>(_ object: T, toDocumentNamed documentName: String, encodedUsing encoder: JSONEncoder = JSONEncoder()) throws {
        let nestedFolderURL = url

        if !manager.fileExists(atPath: nestedFolderURL.relativePath){
            try manager.createDirectory(
                at: nestedFolderURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        }

        let fileURL = nestedFolderURL.appendingPathComponent(documentName)
        let data = try encoder.encode(object)
        try data.write(to: fileURL)
    }

    func writePDF(pdf: PDFDocument, to filename: String){
        let nestedFolderURL = url

        if !manager.fileExists(atPath: nestedFolderURL.relativePath) {
            try! manager.createDirectory(
                at: nestedFolderURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        }

        let fileURL = nestedFolderURL.appendingPathComponent("\(filename).pdf")
        let data = pdf.dataRepresentation()!
        try! data.write(to: fileURL)
    }

    // MARK: - Other

    /// Finds the URLs for all available question papers and mark-scheme papers.
    ///
    /// Note: If there are no papers available in the directory, it finds all available PDFs from the app's resources and writes them here.
    func findAllPaperURLs() -> [URL] {
        let urls = fetchAllAvailablePDFResourceURLs().paperFiltered()
        /*
        if urls == [] {
            for url in fetchAllAvailablePDFResourceURLs().paperFiltered() {
                writePDF(pdf: PDFDocument(url: url)!, to: url.getPaperCode())
            }
        }
        
        urls = findPapers()
        */

        return urls
    }
    
    

    /// Finds the URLs for all question papers and mark-scheme papers in the app bundle
    func fetchAllAvailablePDFResourceURLs() -> [URL] {
        Bundle.main.urls(forResourcesWithExtension: "pdf", subdirectory: "/") ?? []
    }


    private func findPapers() -> [URL] {
        var paperURLs: [URL] = []
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            let papers = directoryContents.filter { $0.pathExtension == "pdf"}
            paperURLs = papers
        } catch {
            print(error.localizedDescription)
        }
        return paperURLs
    }

    // MARK: - Erasure

    func deleteAllFiles() throws {
        for url in try manager.suburls(at: url) {
            try manager.removeItem(at: url)
        }
    }
}
