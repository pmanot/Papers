//
//  SubQuestion.swift
//  Papers
//
//  Created by Purav Manot on 09/07/21.
//

import Foundation

struct SubQuestion: Hashable, Codable {
    var parent: Question
    var index: QuestionIndex
}
