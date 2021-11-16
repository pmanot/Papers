//
// Copyright (c) Purav Manot
//

import Combine
import Swift

class ApplicationStore: ObservableObject {
    let papersDatabase = PapersDatabase()
    let settings: AppSettings
    
    init() {
        papersDatabase.load()
        settings = AppSettings()
    }
}


struct AppSettings {
    var enableDarkMode: Bool = true
}
