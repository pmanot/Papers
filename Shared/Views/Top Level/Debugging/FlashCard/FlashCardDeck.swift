//
// Copyright (c) Purav Manot
//

import SwiftUI

struct FlashCardDeck: View {
    @EnvironmentObject var papersDatabase: PapersDatabase
    @State var deck: [Stack] = [Stack(title: "Example", cards: Card.exampleDeck), Stack(title: "Another example", cards: Card.exampleDeck), Stack(title: "Yet another fucking example", cards: Card.exampleDeck)]
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
                                newStack = Stack.empty
                            }
                            
                        }
                    }
                    .font(.title2, weight: .bold)
                    .foregroundColor(.blue)
                    .opacity(newStack.title.isEmpty ? 0.5 : 1)
                }
            }
            
            ForEach(enumerating: deck) { (index, stack) in
                NavigationLink(destination: FlashCardCollectionView(stack: $deck[index])) {
                    VStack {
                        Text(stack.title)
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
        deck.remove(atOffsets: offsets)
    }
}

struct FlashCardDeck_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FlashCardDeck()
        }
    }
}
