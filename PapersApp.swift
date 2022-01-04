//
// Copyright (c) Purav Manot
//

import SwiftUIX

@main
struct PapersApp: App {
    @StateObject var applicationStore = ApplicationStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(applicationStore)
                .onAppear {
                    print("This please: ", NSHomeDirectory())
                }
        }
    }
}
