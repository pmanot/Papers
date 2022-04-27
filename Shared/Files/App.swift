//
// Copyright (c) Purav Manot
//

import SwiftUIX

@main
struct App: SwiftUI.App {
    @StateObject var applicationStore = ApplicationStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(applicationStore)
                .onAppear {
                    print("HOME DIRECTORY", NSHomeDirectory())
                }
        }
    }
}
