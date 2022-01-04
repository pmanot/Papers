//
// Copyright (c) Purav Manot
//

import Combine
import FoundationX
import Swift

final public class ApplicationStore: ObservableObject {
    let papersDatabase = PapersDatabase()
    let settings: AppSettings
    @Published var tabViewShowing: Bool = true
    
    init() {
        papersDatabase.load()
        settings = AppSettings()
    }
}


struct AppSettings {
    var enableDarkMode: Bool = true
}
