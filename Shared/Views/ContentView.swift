//
// Copyright (c) Purav Manot
//

import SwiftUIX

struct ContentView: View {
    @EnvironmentObject var applicationStore: ApplicationStore

    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: .trayFullFill)
            }

            NavigationView {
                PapersView()
            }
            .tabItem {
                Label("Papers", systemImage: .listDash)
            }

            NavigationView {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: .magnifyingglass)
            }

            NavigationView {
                DebugView()
                    .navigationTitle("Debug")
            }
            .tabItem {
                Label("Debug", systemImage: .gear)
            }
        }
        .environmentObject(applicationStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ApplicationStore())
    }
}
