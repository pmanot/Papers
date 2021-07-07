//
// Copyright (c) Purav Manot
//

import Foundation

struct DocumentDirectory {
    var url: URL {
        getDocumentsDirectory()
    }
    
    func write(_ data: Data, to filename: String){
        let documentURL = url.appendingPathComponent("\(filename).json")
        do {
            try data.write(to: documentURL, atomically: true)
        } catch {
            print("Write Error: ", error.localizedDescription)
        }
    }
    
    func read(from filename: String) -> Data? {
        do {
            let data = try Data(contentsOf: url.appendingPathComponent("\(filename).json"))
            return data
        } catch {
            print("Read Error: ", error.localizedDescription)
            return nil
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

