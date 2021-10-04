//
// Copyright (c) Purav Manot
//

import SwiftUI

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
