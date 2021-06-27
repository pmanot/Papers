//
//  Model.swift
//  PastPapers
//
//  Created by Purav Manot on 25/06/21.
//

import Foundation
import SwiftUI
import PDFKit

struct Paper: Identifiable, Hashable {
    let id = UUID()
    
    static func == (lhs: Paper, rhs: Paper) -> Bool {
        return lhs.url == rhs.url
    }
    
    init(_ paperCode: String){
        self.paperCode = paperCode
        url = URL(fileURLWithPath: Bundle.main.path(forResource: paperCode, ofType: "pdf")!)
        pdf = PDFDocument(url: url)!
        switch paperCode.dropLast(10) {
            case "9702":
                self.subject = .chemistry
            case "9701":
                self.subject = .physics
            default:
                self.subject = .other
        }
        if paperCode.contains("_s"){
            variant = .mayJune
        } else {
            variant = .octNov
        }
        year =  Int("20\(paperCode.dropFirst(12))") ?? 0
    }
    
    let paperCode: String
    let url: URL
    let variant: PaperVariant
    let subject: Subject
    let year: Int
    let pdf: PDFDocument
    var questions: [Question] = []
    
    
    
}


enum PaperVariant: String {
    case febMarch = "Febuary-March"
    case mayJune = "May-June"
    case octNov = "October-November"
}

enum Subject: String {
    case chemistry = "Chemistry"
    case physics = "Physics"
    case other = ""
}


struct Question: Identifiable, Hashable {
    let id = UUID()
    static func == (lhs: Question, rhs: Question) -> Bool {
        (lhs.paper == rhs.paper) && (lhs.index == rhs.index) && (lhs.pages == rhs.pages)
    }
    
    init(paper: Paper, page: [Int], index: Int = 0){
        self.index = index
        self.pages = page
        self.paper = paper
    }
    let pages: [Int]
    let paper: Paper
    var index: Int
}


extension Character {
    func number() -> Int? {
        return Int(String(self))
    }
}


func drawPage(page: PDFPage) -> UIImage? {
    let pageRect = page.bounds(for: .mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
    let img = renderer.image { ctx in
        UIColor.white.set()
        ctx.fill(pageRect)
        ctx.cgContext.translateBy(x: 0, y: pageRect.size.height)
        ctx.cgContext.scaleBy(x: 1, y: -1.0)
        ctx.cgContext.stroke(pageRect)

        ctx.cgContext.drawPDFPage(page.pageRef!)
    }
    return img
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
    func returnMatches(_ string: String, _ length: Int = 50) -> [Int] {
        if matches(string) {
            let range = NSRange(location: 0, length: length)
            return matches(in: string, options: [], range: range).compactMap {
                Int(String(string[Range($0.range, in: string)!]))
            }
        } else {
            return []
        }
    }
}

let examplePaper = Paper("9702_s19_qp_21")
