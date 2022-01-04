//
// Copyright (c) Purav Manot
//

import SwiftUIX

struct ContentView: View {
    @State var isLoading: Bool = true
    var body: some View {
        CustomTabView()
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $isLoading){
                LoadingView(loading: $isLoading)
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
        @State var selectedIndex: Int = 0
        let tabItemSymbols: [SFSymbolName] = [.trayFullFill, .listDash, .magnifyingglass, .rectangleStack, .heart]
        let tabItems: [String] = ["Home", "Papers", "Search", "Flashcards", "Credits"]
        
        var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    NavigationView {
                        HomeView()
                            .environmentObject(applicationStore)
                    }
                    .zIndex(getIndex(0))
                
                    NavigationView {
                        PapersView()
                            .environmentObject(applicationStore)
                    }
                    .zIndex(getIndex(1))
                    
                
                    NavigationView {
                        SearchView()
                    }
                    .zIndex(getIndex(2))
                
                
                    NavigationView {
                        FlashCardDeck(papersDatabase: applicationStore.papersDatabase)
                            .environmentObject(applicationStore)
                    }
                    .zIndex(getIndex(3))
                    
                    NavigationView {
                        CreditsView()
                    }
                    .zIndex(getIndex(4))
                }
                
                Divider()
                
                HStack {
                    ForEach(enumerating: tabItems, id: \.self){ (index, item) in
                        Button(action: {selectedIndex = index}) {
                            Spacer()
                            VStack(spacing: 5) {
                                Image(systemName: tabItemSymbols[index])
                                    .font(.title3)
                                Text(item)
                                    .font(.caption)
                            }
                            Spacer()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(index == selectedIndex ? .systemPink : .secondaryLabel)
                    }
                }
                .padding(5)
                .background(Color.background)
            }
        }
    }
}

extension ContentView.CustomTabView {
    func getIndex(_ selfValue: Int) -> Double {
        selectedIndex == selfValue ? 4 : 0
    }
}
