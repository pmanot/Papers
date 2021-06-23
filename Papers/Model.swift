//
//  Model.swift
//  Papers
//
//  Created by Purav Manot on 27/05/21.
//

import Foundation
import SwiftUI
import PDFKit

struct Question {
    init(paperCode: String, index: Int = 3){
        self.index = index
        url = URL(fileURLWithPath: Bundle.main.path(forResource: paperCode, ofType: "pdf")!)
        self.paperCode = paperCode
    }
    let paperCode: String
    let url: URL
    let index: Int
    var answer: [Answer] = []
}

struct Answer {
    let index: Int
    let image: Image
    let question: [Question]
}
