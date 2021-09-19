//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

final public class Papers: ObservableObject {
    let directory = DocumentDirectory()
    @Published var cambridgePapers: [QuestionPaper]
    
    var papers: [Paper] {
        if let data = directory.read(from: "Papers") {
            return try! JSONDecoder().decode([Paper].self, from: data)
        }
        return []
    }
    
    init(){
        if let data = directory.read(from: "metadata"){
            cambridgePapers = try! JSONDecoder().decode([QuestionPaper].self, from: data)
        } else {
            cambridgePapers = []
        }
    }
    
    func typeCheck(pdf: PDFDocument) -> Bool {
        if let url = pdf.documentURL {
            if url.absoluteString.contains("9701_") || url.absoluteString.contains("9702_") {
                return true
            }
        }
        return false
    }
    
    func load(){
        if let data = directory.read(from: "metadata"){
            cambridgePapers = try! JSONDecoder().decode([QuestionPaper].self, from: data)
        } else {
            cambridgePapers = []
        }
    }
    
}

extension Papers {
    static let examples = [QuestionPaper("9701_m20_qp_42"), QuestionPaper("9702_w20_qp_22"), QuestionPaper("9702_s19_qp_21"), QuestionPaper.example2]
}
