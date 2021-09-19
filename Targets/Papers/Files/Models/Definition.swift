//
//  Definition.swift
//  Papers
//
//  Created by Purav Manot on 11/07/21.
//

import Foundation

struct Definition: Codable, Hashable {
    var id = UUID()
    let question: Question?
    let term: String
    let definition: String
    init(of term: String, is definition: String){
        self.term = term
        self.definition = definition
        self.question = nil
    }
}
