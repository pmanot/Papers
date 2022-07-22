//
// Copyright (c) Purav Manot
//

import Foundation

public struct CambridgePaperDetails: Codable, Hashable {
    public let paperFilename: PaperFilename
    public let number: CambridgePaperNumber?
    public let variant: CambridgePaperVariant?
    public let subject: CambridgeSubject?
    public let month: CambridgePaperMonth?
    public let year: Int?
    
    public init(paperFilename: PaperFilename) {
        self.paperFilename = paperFilename
        self.number = .init(paperFilename: paperFilename)
        self.variant = .init(paperFilename: paperFilename)
        self.subject = .init(paperFilename: paperFilename)
        self.month = .init(paperFilename: paperFilename)
        self.year = 2000 + Int(paperFilename.rawValue.split(separator: "_")[1].filter({ $0.isNumber }))!
    }
}
