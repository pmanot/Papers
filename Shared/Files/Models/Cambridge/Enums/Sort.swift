//
// Copyright (c) Purav Manot
//

import Foundation

enum SortType {
    case sortByYear
    case sortByMonth
    case sortBySubject
    case sortByPaperNumber
}

enum SortOrder {
    case ascending
    case descending
}

enum SortArgument: Hashable {
    case year(_ i: Int)
    case month(_ i: CambridgePaperMonth)
    case subject(_ i: CambridgeSubject)
    case paperNumber(_ i: CambridgePaperNumber)
}
