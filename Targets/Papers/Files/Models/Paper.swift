//
// Copyright (c) Purav Manot
//

import PDFKit
import SwiftUIX

struct Paper: Identifiable, Hashable {
    let id = UUID()
    let paperCode: String
    let url: URL
    let year: Int
    let pdf: PDFDocument
    let markscheme: MarkScheme?
    var questions: [Question] = []
    
    var subject: Subject {
        switch paperCode.dropLast(10) {
            case "9702":
                return .chemistry
            case "9701":
                return .physics
            default:
                return .other
        }
    }
    
    var variant: PaperVariant {
        if paperCode.contains("_s"){
            return .mayJune
        } else {
            return .octNov
        }
    }
    
    init(_ paperCode: String) {
        self.paperCode = paperCode
        
        url = URL(fileURLWithPath: Bundle.main.path(forResource: paperCode, ofType: "pdf")!)
        pdf = PDFDocument(url: url)!
        year = Int("20\(paperCode.dropFirst(12))") ?? 0
        
        let msCode = paperCode.replacingOccurrences(of: "qp", with: "ms")
        if Bundle.main.path(forResource: msCode, ofType: "pdf") != nil {
            markscheme = MarkScheme(msCode)
        } else {
            markscheme = nil
        }
        
        extractQuestions()
    }
    
    mutating func extractQuestions() {
        var questionPages: [Int: [Int]] = [:]
        var questionNumber: Int = 1
        var lastIndex: Int = 0
        
        for pageNumber in 4..<pdf.pageCount {
            let textData = (pdf.page(at: pageNumber)?.string!)!
            let regex = try! NSRegularExpression(pattern: "[0-9]*")
            let possibleIndices = regex.returnMatches(textData).sorted(by: { $0 <= $1 })
            
            for index in possibleIndices {
                if index == questionNumber {
                    questionPages[index] = [pageNumber]
                    questionNumber += 1
                    lastIndex = index
                }
            }
            
            if lastIndex != 0 {
                if !(questionPages[lastIndex]!.contains(pageNumber)) {
                    questionPages[lastIndex]!.append(pageNumber)
                }
            }
        }
        
        for index in questionPages.keys {
            if questionPages[index] != [] {
                questions.append(Question(paper: self, page: questionPages[index]!, index: index))
                questions.sort(by: {$0.index < $1.index})
            }
        }
    }
    
    
    
}

extension Paper {
    static let example = Paper("9702_s19_qp_21")
}

struct MarkScheme: Identifiable, Hashable {
    let id = UUID()
    let msCode: String
    let url: URL
    let year: Int
    let pdf: PDFDocument
    var answers: [Answer] = []
    
    init(_ msCode: String) {
        self.msCode = msCode
        
        url = URL(fileURLWithPath: Bundle.main.path(forResource: msCode, ofType: "pdf")!)
        pdf = PDFDocument(url: url)!
        year = Int("20\(msCode.dropFirst(12))") ?? 0
        
        extractAnswers()
    }
    
    mutating func extractAnswers() {
        var answerPages: [Int: [Int]] = [:]
        var answerNumber: Int = 1
        
        for pageNumber in 3..<pdf.pageCount {
            answerPages[answerNumber] = [pageNumber]
            answerNumber += 1
        }
        
        for index in answerPages.keys {
            if answerPages[index] != [] {
                answers.append(Answer(markscheme: self, page: answerPages[index]!, index: index))
                answers.sort(by: {$0.index < $1.index})
            }
        }
    }
    
}
