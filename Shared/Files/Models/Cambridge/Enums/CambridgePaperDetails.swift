//
// Copyright (c) Purav Manot
//

import Foundation

public struct CambridgePaperDetails: Codable, Hashable {
    init(paperCode: String) {
        self.code = paperCode
        self.number = .init(paperCode: paperCode)
        self.variant = .init(paperCode: paperCode)
        self.subject = .init(paperCode: paperCode)
        self.month = .init(paperCode: paperCode)
        self.year = 2000 + Int(paperCode.split(separator: "_")[1].filter { $0.isNumber })!
    }
    public let code: String
    public let number: CambridgePaperNumber?
    public let variant: CambridgePaperVariant?
    public let subject: CambridgeSubject?
    public let month: CambridgePaperMonth?
    public let year: Int?
}
