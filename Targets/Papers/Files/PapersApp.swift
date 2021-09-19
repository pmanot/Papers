//
// Copyright (c) Purav Manot
//

import SwiftUI
import Filesystem

@main

struct PapersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Papers())
        }
    }
}
