//
// Copyright (c) Purav Manot
//

import PDFKit
import Filesystem

struct QuestionPaper: Identifiable, Hashable {
    let id = UUID()
    let paperCode: String
    let year: Int
    let pdf: PDFDocument
    let markscheme: MarkScheme?
    var questions: [Question] = []
    var pages: [PDFPage] = []
    
    var subject: Subject {
        switch paperCode.dropLast(10) {
            case "9701":
                return .chemistry
            case "9702":
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
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: paperCode, ofType: "pdf")!)
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
    
    init(_ pdf: PDFDocument){
        self.paperCode = ""
        self.pdf = pdf
        year = Int("20\(paperCode.dropFirst(12))") ?? 0
        markscheme = MarkScheme.example
    }
    
    mutating func extractQuestions() {
        var questionPages: [Int: [Int]] = [:]
        var questionNumber: Int = 1
        var lastIndex: Int = 0
        
        for pageNumber in 4..<pdf.pageCount {
            let textData = (pdf.page(at: pageNumber)?.string!)!
            let regex = try? NSRegularExpression(pattern: String(questionNumber))
            
            if regex!.matches(textData) {
                questionPages[questionNumber] = [pageNumber]
                lastIndex = questionNumber
                questionNumber += 1
                print(pageNumber)
            }
            
            if lastIndex != 0 {
                if !(questionPages[lastIndex]! == [pageNumber]) {
                    questionPages[lastIndex]!.append(pageNumber)
                    print(pageNumber)
                }
            }
        }
        
        for index in questionPages.keys {
            if questionPages[index] != [] {
                questions.append(Question(paper: self, page: questionPages[index]!, index: index))
                questions.sort(by: {$0.index.number < $1.index.number})
            }
        }
    }
    
    
    
}

extension QuestionPaper {
    static let example = Paper("9702_s19_qp_21")
    static let exampleMs = MarkScheme("9702_s19_ms_21")
}
