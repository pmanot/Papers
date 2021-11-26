//
// Copyright (c) Purav Manot
//

import Combine
import FoundationX
import Swift

final public class ApplicationStore: ObservableObject {
    @Published var childViewActive = false
    
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
