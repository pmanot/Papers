//
// Copyright (c) Purav Manot
//

import SwiftUI
import Diagnostics

struct DebugView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Debugging")
    
    var body: some View {
        Form {
            Section(header: "Paper-related Data") {
                Button("Delete") {
                    do {
                        try applicationStore.papersDatabase.eraseAllData()
                    } catch {
                        Self.logger.error(error)
                    }
                }

                Button("Load") {
                    applicationStore.papersDatabase.load()
                }
            }
        }
    }
}
