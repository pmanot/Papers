//
// Copyright (c) Purav Manot
//


import Foundation
import SwiftUI

struct Tag: Hashable {
    var search: String
    var type: TagType
    var color: Color {
        switch type {
        case .answer:
            return tagColors[4]
        case .question:
            return tagColors[2]
        case .papercode:
           return tagColors[3]
        }
    }
    var initialiser: String {
        switch type {
        case .answer:
            return "a#"
        case .question:
            return "q#"
        case .papercode:
           return "p#"
        }
    }
    
    init(_ search: String, type: TagType){
        self.search = search
        self.type = type
    }
}


let tagColors = [Color(237, 246, 229), Color(181, 234, 234), Color(246, 174, 153), Color(247, 219, 240), Color(202, 247, 227), Color(241, 202, 137), Color(253, 255, 188), Color(195, 174, 214), Color(203, 226, 176), Color(190, 235, 233), Color(156, 241, 150), Color(255, 197, 161)]


enum TagType: String {
    case papercode = "PaperCode"
    case question = "Question"
    case answer = "Answer"
}
