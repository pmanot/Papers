//
// Copyright (c) Purav Manot
//

import Foundation

struct DocumentDirectory {
    var url: URL {
        getDocumentsDirectory()
    }
    
    func write(_ string: String, to location: String){
        let documentURL = url.appendingPathComponent("\(location).json")
        do {
            try string.write(to: documentURL, atomically: true, encoding: .utf8)
        } catch {
            print("Write Error: ", error.localizedDescription)
        }
    }
    
    func read(from location: String) -> String {
        do {
            let str = try String(contentsOf: url.appendingPathComponent("\(location).json"))
            return str
        } catch {
            print("Read Error: ", error.localizedDescription)
        }
        return ""
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

