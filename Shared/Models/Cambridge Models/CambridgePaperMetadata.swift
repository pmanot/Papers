//
// Copyright (c) Purav Manot
//

import Foundation
import PDFKit

struct CambridgePaperMetadata: Codable, Hashable {
    static let paperCodePattern = "[0-9]{4}_[a-z]{1}[0-9]{2}_[a-z]{2}_[0-9]{2}"
    
    let paperCode: String
    let questionPaperCode: String
    let paperType: CambridgePaperType
    let month: CambridgePaperMonth
    let year: Int
    let subject: CambridgeSubject
    let paperNumber: CambridgePaperNumber
    let paperVariant: CambridgePaperVariant
    var pageData: [CambridgePaperPage] = []
    
    init(paperCode: String){
        if regexMatches(string: paperCode, pattern: CambridgePaperMetadata.paperCodePattern) { // check if papercode is valid
            self.paperCode = paperCode
            self.questionPaperCode = getQuestionPaperCode(paperCode)
            let paperCodeChunks = paperCode.split(separator: "_")
            
            self.paperType = CambridgePaperType(paperCode: paperCode)
            self.paperNumber = CambridgePaperNumber(paperCode: paperCode)
            self.paperVariant = CambridgePaperVariant(paperCode: paperCode)
            self.month = CambridgePaperMonth(paperCode: paperCode)
            self.subject = CambridgeSubject(paperCode: paperCode)
            self.year = Int(paperCodeChunks[1].dropFirst())!
        } else { // papercode is not valid
            self.paperCode = "uncategorised"
            self.questionPaperCode = "uncategorised"
            self.paperNumber = CambridgePaperNumber.paper1
            self.paperType = CambridgePaperType.other
            self.paperVariant = CambridgePaperVariant.variant1
            self.month = CambridgePaperMonth.febMarch
            self.year = 00
            self.subject = .other
        }
    }
    
    init(url: URL){
        self.init(paperCode: url.deletingPathExtension().lastPathComponent)
        fetchPageData(pdf: PDFDocument(url: url)!)
    }
    
    init(bundleResourceName: String){
        self.init(url: URL(fileURLWithPath: Bundle.main.path(forResource: bundleResourceName, ofType: "pdf")!))
    }
    
    mutating func fetchPageData(pdf: PDFDocument) {
        var nextQuestionNumber: Int = 1
        var runningQuestionNumber: Int = 0
        
        for i in 0..<pdf.pageCount {
            let pageNumber = i + 1
            let page = pdf.page(at: i)!
            let rawPageText = page.string ?? ""
            
            if rawPageText.contains("BLANK PAGE") { // blank page detected
                pageData.append(CambridgePaperPage(type: .blank, rawText: "", pageNumber: pageNumber))
            } else {
                let snapshot = page.snapshot().cgImage!
                let croppedSnapshot = snapshot.cropping(to: CGRect(origin: CGPoint(x: 50, y: 0), size: CGSize(width: 100, height: 1000)))! // crop page snapshot to only include page number
                
                if recogniseText(from: croppedSnapshot).contains("\(nextQuestionNumber)"){ //page containing new question
                    runningQuestionNumber = nextQuestionNumber
                    nextQuestionNumber += 1
                    
                    let index = QuestionIndex(runningQuestionNumber)
                    pageData.append(CambridgePaperPage(type: .questionPaperPage(index: index), rawText: rawPageText, pageNumber: pageNumber))
                    
                } else { //continuation of previous question
                    let index = QuestionIndex(runningQuestionNumber)
                    pageData.append(CambridgePaperPage(type: .questionPaperPage(index: index), rawText: rawPageText, pageNumber: pageNumber))
                }
            }
        }
        print("page data calculated")
    }
}

extension Array where Element == CambridgePaperMetadata {
    func matching(_ url: URL) -> CambridgePaperMetadata? {
        self.first { $0.paperCode == url.getPaperCode() }
    }
}

func getQuestionPaperCode(_ paperCode: String) -> String {
    var extendedPaperCode: String = ""
    let paperCodeChunks = paperCode.split(separator: "_")
    extendedPaperCode += "\(paperCodeChunks[0])/"
    extendedPaperCode += "\(paperCodeChunks[3])/"
    switch paperCodeChunks[1].dropLast(2) {
    case "s":
        extendedPaperCode += "M/J/"
    case "w":
        extendedPaperCode += "O/N/"
    case "m":
        extendedPaperCode += "F/M/"
    default:
        extendedPaperCode += "F/M/"
    }
    extendedPaperCode += "\(paperCodeChunks[1].dropFirst())"
    
    return extendedPaperCode
}
