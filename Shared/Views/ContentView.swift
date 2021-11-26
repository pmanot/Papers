//
// Copyright (c) Purav Manot
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    var body: some View {
        ZStack {
            TabView {
                NavigationView {
                    Home()
                }
                .tabItem {
                    Label("Home", systemImage: "tray.full.fill")
                }
                NavigationView {
                    PapersView()
                }
                .tabItem {
                    Label("Papers", systemImage: "list.dash")
                }
                NavigationView {
                    SearchView()
                }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
            }
            .zIndex(0)
            .environmentObject(applicationStore)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ApplicationStore())
    }
}
