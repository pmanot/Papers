//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgePaperType: Codable, Hashable {
    public struct CambridgePaperDetails: Codable, Hashable {
        init(paperCode: String) {
            self.number = .init(paperCode: paperCode)
            self.variant = .init(paperCode: paperCode)
            self.subject = .init(paperCode: paperCode)
            self.month = .init(paperCode: paperCode)
            self.year = 2000 + Int(paperCode.split(separator: "_")[1].filter { $0.isNumber })!
            print(year)
        }
        public let number: CambridgePaperNumber
        public let variant: CambridgePaperVariant
        public let subject: CambridgeSubject
        public let month: CambridgePaperMonth
        public let year: Int
    }
    
    case markScheme(details: CambridgePaperDetails)
    case questionPaper(details: CambridgePaperDetails)
    case datasheet
    case examinerReport
    case other
}

extension CambridgePaperType {
    init(){
        self = .other
    }
    
    init(paperCode: String) {
        let paperCodeChunks = paperCode.split(separator: "_")
        switch paperCodeChunks[2] {
        case "qp":
                self = .questionPaper(details: .init(paperCode: paperCode))
        case "ms":
                self = .markScheme(details: .init(paperCode: paperCode))
        default:
            self = .datasheet
        }
    }
}
