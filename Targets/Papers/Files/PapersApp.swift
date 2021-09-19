//
// Copyright (c) Purav Manot
//

import SwiftUI
import Filesystem

@main
struct PapersApp: App {
    @StateObject var applicationStore = ApplicationStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(applicationStore)
        }
    }
}
