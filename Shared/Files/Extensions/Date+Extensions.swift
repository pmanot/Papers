//
// Copyright (c) Purav Manot
//

import Foundation

extension Date {
    var relativeDescription: String {
        let relativeWords: [String] = ["Today", "Yesterday"]
        switch self.daysToNow {
            case 0:
                return relativeWords[0]
            case 1:
                return relativeWords[1]
            default:
                return "\(self.daysToNow) days ago"
        }
    }
}
