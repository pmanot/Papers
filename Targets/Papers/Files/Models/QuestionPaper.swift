//
// Copyright (c) Purav Manot
//

import PDFKit
import Filesystem
import SwiftUI

struct QuestionPaper: Identifiable, Hashable {
    let id = UUID()
    let metadata: CambridgeMetaData
    let pdf: PDFDocument
    let markscheme: MarkScheme?
    var questions: [Question] = []
    var extractedText = ""
    
    init(_ paperCode: String) {
        metadata = CambridgeMetaData(paperCode: paperCode)
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: paperCode, ofType: "pdf")!)
        pdf = PDFDocument(url: url)!
        
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
        var firstPageIgnoringDatasheet: Int {
            switch metadata.subject {
            case .physics:
                return 3
            case .chemistry:
                return 0
            default:
                return 3
            }
        }
        
        for pageNumber in firstPageIgnoringDatasheet..<pdf.pageCount {
            if !pdf.page(at: pageNumber)!.string!.contains("BLANK PAGE") {
                
                let page = pdf.page(at: pageNumber)!.snapshot().cgImage!.cropping(to: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 150, height: 1000)))!
                let extractedText = recogniseText(from: page)
                
                print(extractedText)
                
                if extractedText.contains(substring: "\(questionNumber)"){
                    print(extractedText)
                    
                    questionPages[questionNumber] = [pageNumber]
                    lastIndex = questionNumber
                    questionNumber += 1
                } else {
                    if questionPages[lastIndex] != nil {
                        questionPages[lastIndex]!.append(pageNumber)
                        print(pageNumber)
                        
                    }
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
