//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX
import UXKit

struct ContentView: View {
    enum Destination: String, CaseIterable, Codable, HashIdentifiable {
        case home
        case papers
        case search
        case flashCards
        case credits
        
        var title: String {
            switch self {
                case .home:
                    return "Home"
                case .papers:
                    return "Papers"
                case .search:
                    return "Search"
                case .flashCards:
                    return "Flashcards"
                case .credits:
                    return "Credits"
            }
        }
        
        var icon: SFSymbolName {
            switch self {
                case .home:
                    return .trayFullFill
                case .papers:
                    return .listDash
                case .search:
                    return .magnifyingglass
                case .flashCards:
                    return .rectangleStack
                case .credits:
                    return .heart
            }
        }
    }
    
    @EnvironmentObject var applicationStore: ApplicationStore

    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom

    @UserStorage("rootView.selection") private var selection: Destination = .home
    
    @State private var isLoading: Bool = true
    
    var body: some View {
        navigationView
            .titleBarHidden(true)
            .fullScreenCover(isPresented: $isLoading){
                LoadingView(loading: $isLoading)
            }
    }
    
    @ViewBuilder
    var navigationView: some View {
        if userInterfaceIdiom == .pad || userInterfaceIdiom == .mac {
            AdaptiveNavigationView("Papers", selection: $selection) {
                HomeView()
                    .environmentObject(applicationStore)
                    .initialSidebarVisibility(.visible)
                    .navigatableItem(tag: Destination.home) {
                        TabItem(item: .home)
                    }
                
                PapersView()
                    .environmentObject(applicationStore)
                    .initialSidebarVisibility(.visible)
                    .navigatableItem(tag: Destination.papers) {
                        TabItem(item: .papers)
                    }
                
                SearchView()
                    .initialSidebarVisibility(.visible)
                    .navigatableItem(tag: Destination.search) {
                        TabItem(item: .search)
                    }
                
                FlashCardDeck(papersDatabase: applicationStore.papersDatabase)
                    .environmentObject(applicationStore)
                    .initialSidebarVisibility(.visible)
                    .navigatableItem(tag: Destination.flashCards) {
                        TabItem(item: .flashCards)
                    }
                
                CreditsView()
                    .initialSidebarVisibility(.visible)

                    .navigatableItem(tag: Destination.credits) {
                        TabItem(item: .credits)
                    }

            } placeholder: {
                Text("No Selection")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        } else {
            CustomTabView(selection: $selection)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ApplicationStore())
    }
}

extension ContentView {
    struct CustomTabView: View {
        @EnvironmentObject var applicationStore: ApplicationStore
        
        @State var showingTabView: Bool = true
        @Binding var selection: Destination
        
        var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    NavigationView {
                        HomeView()
                            .environmentObject(applicationStore)
                    }
                    .zIndex(getIndex(for: .home))

                    NavigationView {
                        PapersView()
                            .environmentObject(applicationStore)
                    }
                    .zIndex(getIndex(for: .papers))

                    NavigationView {
                        SearchView()
                    }
                    .zIndex(getIndex(for: .search))

                    NavigationView {
                        FlashCardDeck(papersDatabase: applicationStore.papersDatabase)
                            .environmentObject(applicationStore)
                    }
                    .zIndex(getIndex(for: .flashCards))
                    
                    NavigationView {
                        CreditsView()
                    }
                    .zIndex(getIndex(for: .credits))
                }
                
                Divider()
                
                HStack {
                    ForEach(Destination.allCases) { item in
                        Button(action: { selection = item }) {
                            Spacer()
                            
                            TabItem(item: item)
                            
                            Spacer()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(item == selection ? .systemPink : .secondaryLabel)
                    }
                }
                .padding(5)
                .background(Color.background)
            }
        }
    }
    
    struct TabItem: View {
        @Environment(\.userInterfaceIdiom) private var userInterfaceIdiom

        let item: Destination
        
        var body: some View {
            if userInterfaceIdiom == .pad || userInterfaceIdiom == .mac {
                Label(item.title, systemImage: item.icon)
            } else {
                VStack(spacing: 5) {
                    Image(systemName: item.icon)
                        .font(.title3)
                    
                    Text(item.title)
                        .font(.caption)
                }
            }
        }
    }
}

extension ContentView.CustomTabView {
    func getIndex(for destination: ContentView.Destination) -> Double {
        selection == destination ? 4 : 0
    }
}
