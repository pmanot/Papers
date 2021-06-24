//
//  Model.swift
//  Papers
//
//  Created by Purav Manot on 27/05/21.
//

import Foundation
import SwiftUI
import PDFKit

struct Paper: Identifiable, Hashable {
    static func == (lhs: Paper, rhs: Paper) -> Bool {
        lhs.paperCode == rhs.paperCode
    }
    
    init(paperCode: String){
        self.paperCode = paperCode
        if let path = Bundle.main.path(forResource: paperCode, ofType: "pdf"){
            url = URL(fileURLWithPath: path)
            pdf = PDFDocument(url: url!)
        } else {
            url = nil
            pdf = nil
        }
        if paperCode.contains("_s"){
            variant = .febMarch
        }
    }
    let id = UUID()
    let url: URL?
    let pdf: PDFDocument?
    let paperCode: String
    var variant: PaperVariant?
    var questions: [Question] = []
}

struct Question: Identifiable, Hashable {
    static func == (lhs: Question, rhs: Question) -> Bool {
        (lhs.paperCode == rhs.paperCode) && (lhs.index == rhs.index)
    }
    
    init(paperCode: String, index: Int = 3){
        self.index = index
        url = URL(fileURLWithPath: Bundle.main.path(forResource: paperCode, ofType: "pdf")!)
        self.paperCode = paperCode
    }
    let id = UUID()
    let paperCode: String
    let url: URL
    let index: Int
    var answer: [Answer] = []
}

struct Answer: Identifiable, Hashable {
    let id = UUID()
    let index: Int
    let question: [Question]
}

enum PaperVariant {
    case febMarch
    case mayJune
    case octNov
}
