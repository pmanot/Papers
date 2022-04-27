//
// Copyright (c) Purav Manot
//

import FoundationX
import Merge

final public class ApplicationStore: ObservableObject {
    struct Settings: Codable {
        var isDarkModeOverrideEnabled: Bool = false
    }
    
    let papersDatabase = PapersDatabase()
    
    @UserDefault.Published("settings")
    var settings = Settings()
    
    init() {
        papersDatabase.load()
        settings = Settings()
    }
}
