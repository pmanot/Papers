//
//  Answers.swift
//  Papers
//
//  Created by Purav Manot on 04/07/21.
//

import Foundation

public final class Answers: ObservableObject {
    var data: CodableAnswers
    init(_ answers: [Answer] = []){
        self.data = CodableAnswers(answers)
    }
    
    func save(_ answers: [Answer]){
        if answers.count != 0 {
            let directory = DocumentDirectory()
            self.data = CodableAnswers(answers)
            let jsonData = try! JSONEncoder().encode(data)
            let jsonString = String(data: jsonData, encoding: .utf8)
            directory.write(jsonString!, to: data.paperCode)
        }
    }
    
    func fetch() -> CodableAnswers {
        let directory = DocumentDirectory()
        let jsonString = directory.read(from: data.paperCode)
        let decodedData = try! JSONDecoder().decode(CodableAnswers.self, from: Data(jsonString.utf8))
        return decodedData
    }
}
