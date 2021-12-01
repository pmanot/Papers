//
// Copyright (c) Purav Manot
//

import SwiftUI

struct DebugView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    
    var body: some View {
        Form {
            Section(header: "Paper-related Data") {
                Button("Delete") {
                    do {
                        try applicationStore.papersDatabase.eraseAllData()
                    } catch {
                        print("Error: \(error)")
                    }
                }

                Button("Load") {
                    applicationStore.papersDatabase.load()
                }
            }
        }
    }
}
