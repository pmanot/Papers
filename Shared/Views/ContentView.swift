//
// Copyright (c) Purav Manot
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    var body: some View {
        PapersView()
            .environmentObject(applicationStore.papersDatabase)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
