//
//  SubQuestion.swift
//  Papers
//
//  Created by Purav Manot on 09/07/21.
//

import Foundation

struct SubQuestion: Hashable, Codable {
    var index: QuestionIndex
    
    init(_ index: QuestionIndex){
        self.index = index
    }
}
