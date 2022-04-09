//
// Copyright (c) Purav Manot
//

import Foundation

public enum CambridgePaperKind: String, Codable, Hashable {
    case longAnswer = "Long Answer"
    case multipleChoice = "MCQ"
    case other = "Uncategorised"
}

extension CambridgePaperKind {
    init(){
        self = .other
    }
    
    init(paperCode: String) {
        let subject = CambridgeSubject(paperCode: paperCode)
        let number = CambridgePaperNumber(paperCode: paperCode)
        
        switch subject {
            case .chemistry, .physics, .biology:
                switch number {
                    case .paper1:
                        self = .multipleChoice
                    case .paper2, .paper3, .paper4, .paper5, .paper6:
                        self = .longAnswer
                }
            case .maths:
                self = .longAnswer
            case .english:
                self = .longAnswer
            case .other:
                self = .other
        }
    }
}
