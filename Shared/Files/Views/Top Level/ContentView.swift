//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct ContentView: View {
    enum Destination: String, CaseIterable, Codable, HashIdentifiable {
        case home
        case papers
        case flashCards
        case saved
        
        var title: String {
            switch self {
                case .home:
                    return "Home"
                case .papers:
                    return "Papers"
                case .flashCards:
                    return "Flashcards"
                case .saved:
                    return "Saved"
            }
        }
        
        var icon: SFSymbolName {
            switch self {
                case .home:
                    return .trayFullFill
                case .papers:
                    return .listDash
                case .flashCards:
                    return .rectangleStack
                case .saved:
                    return .bookmark
            }
        }
    }
    
    @EnvironmentObject var applicationStore: ApplicationStore

    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom

    @State private var selection: Destination? = .home
    @State private var isLoading: Bool = true
    
    var body: some View {
        navigationView
            .titleBarHidden(true)
    }
    
    @ViewBuilder
    var navigationView: some View {
        if userInterfaceIdiom == .pad || userInterfaceIdiom == .mac {
            NavigationView {
                List {
                    NavigationLink(tag: Destination.home, selection: $selection) {
                        HomeView()
                            .environmentObject(applicationStore)
                    } label: {
                        TabItem(item: .home)
                    }
                    
                    NavigationLink(tag: Destination.papers, selection: $selection) {
                        PapersView()
                            .environmentObject(applicationStore)
                    } label: {
                        TabItem(item: .papers)
                    }
                    
                    NavigationLink(tag: Destination.flashCards, selection: $selection) {
                        FlashCardDeck(papersDatabase: applicationStore.papersDatabase)
                            .environmentObject(applicationStore)
                    } label: {
                        TabItem(item: .flashCards)
                    }
                    
                    NavigationLink(tag: Destination.saved, selection: $selection) {
                        SavedCollectionView(papersDatabase: applicationStore.papersDatabase)
                            .environmentObject(applicationStore)
                    } label: {
                        TabItem(item: .saved)
                    }
                }
                .listStyle(SidebarListStyle())
            }
        } else {
            CustomTabView(selection: $selection)
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
        @Binding var selection: Destination?
        
        var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    NavigationView {
                        HomeView()
                            .environmentObject(applicationStore)
                    }
                    .navigationViewStyle(.stack)
                    .zIndex(getIndex(for: .home))

                    NavigationView {
                        PapersView()
                            .environmentObject(applicationStore)
                    }
                    .navigationViewStyle(.stack)
                    .zIndex(getIndex(for: .papers))

                    NavigationView {
                        FlashCardDeck(papersDatabase: applicationStore.papersDatabase)
                            .environmentObject(applicationStore)
                    }
                    .zIndex(getIndex(for: .flashCards))
                    
                    NavigationView {
                        SavedCollectionView(papersDatabase: applicationStore.papersDatabase)
                            .environmentObject(applicationStore)
                    }
                    .zIndex(getIndex(for: .saved))
                }
                
                Divider()
                
                HStack {
                    ForEach(Destination.allCases) { item in
                        Button(action: { selection = item }) {
                            HStack {
                                Spacer()
                                
                                TabItem(item: item)
                                
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(item == selection ? .accentColor : .secondaryLabel)
                    }
                }
                .padding(5)
                .background(Color.primaryInverted)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
                        .font(.title2)
                    
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
