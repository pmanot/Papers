//
// Copyright (c) Purav Manot
//

import Combine
import Swift

class ApplicationStore: ObservableObject {
    let papersDatabase = PapersDatabase()
    
    init() {
        papersDatabase.load()
    }
}
