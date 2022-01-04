//
// Copyright (c) Purav Manot
//

import SwiftUI

struct FlashCardDeck: View {
    @ObservedObject var papersDatabase: PapersDatabase
    @State var deck: [Stack] = []
    @State var newStack: Stack = Stack.empty
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Create a new stack", text: $newStack.title)
                        .font(.headline, weight: .regular)
                        .padding()
                    
                    SymbolButton("plus.circle.fill"){
                        if !newStack.title.isEmpty {
                            withAnimation {
                                papersDatabase.deck.insert(newStack)
                                deck.append(newStack)
                                save()
                                newStack = Stack.empty
                            }
                            
                        }
                    }
                    .font(.title2, weight: .bold)
                    .foregroundColor(.blue)
                    .opacity(newStack.title.isEmpty ? 0.5 : 1)
                }
            }
            
            ForEach(enumerating: papersDatabase.deck) { (index, stack) in
                NavigationLink(destination: FlashCardCollectionView(stack: $papersDatabase.deck[index], papersDatabase: papersDatabase)) {
                    VStack {
                        Text(stack.title)
                            .fontWeight(.regular)
                            .font(.headline, weight: .regular)
                            
                    }
                    .padding()
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Deck")
    }
}

extension FlashCardDeck {
    func delete(at offsets: IndexSet) {
        papersDatabase.deck.remove(atOffsets: offsets)
        papersDatabase.saveDeck()
    }
    
    func save(){
        papersDatabase.saveDeck()
    }
}

struct FlashCardDeck_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FlashCardDeck(papersDatabase: PapersDatabase())
        }
    }
}
