//
//  CambridgePaperDetails.swift
//  Papers
//
//  Created by Purav Manot on 10/04/22.
//

import Foundation

public struct CambridgePaperDetails: Codable, Hashable {
    init(paperCode: String) {
        self.number = .init(paperCode: paperCode)
        self.variant = .init(paperCode: paperCode)
        self.subject = .init(paperCode: paperCode)
        self.month = .init(paperCode: paperCode)
        self.year = 2000 + Int(paperCode.split(separator: "_")[1].filter { $0.isNumber })!
    }
    public let number: CambridgePaperNumber?
    public let variant: CambridgePaperVariant?
    public let subject: CambridgeSubject?
    public let month: CambridgePaperMonth?
    public let year: Int?
}
