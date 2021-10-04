//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct DocumentDirectory {
    var url: URL { try!
        manager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
    
    var manager = FileManager.default
    
    func write(_ data: Data, to filename: String){
        let documentURL = url.appendingPathComponent("\(filename).json")
        do {
            try data.write(to: documentURL, options: .atomic)
        } catch {
            print("Write Error: ", error.localizedDescription)
        }
    }
    
    func write<T: Encodable>(
            _ object: T,
            toDocumentNamed documentName: String,
            encodedUsing encoder: JSONEncoder = .init()
        ) throws {
        
            let nestedFolderURL = url.appendingPathComponent("Paper Directory")

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
        let nestedFolderURL = url.appendingPathComponent("Paper Directory")

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
    
    
    func read(from filename: String) -> Data? {
        do {
            let nestedFolderURL = url.appendingPathComponent("Paper Directory")

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
    
    func findPapers() -> [URL] {
        var paperURLs: [URL] = []
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url.appendingPathComponent("Paper Directory"), includingPropertiesForKeys: nil)
            let papers = directoryContents.filter { $0.pathExtension == "pdf"}
            paperURLs = papers
        } catch {
            print(error.localizedDescription)
        }
        return paperURLs
    }
}

func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}
