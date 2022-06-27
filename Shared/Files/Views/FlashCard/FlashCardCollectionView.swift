//
//  FlashCardCollectionView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 29/12/21.
//

import SwiftUI
import Merge

struct FlashCardCollectionView: View {
    @Binding var stack: Stack
    @State private var flashCardViewShowing: Bool = false
    
    @ObservedObject var papersDatabase: PapersDatabase
    
    var body: some View {
        Group {
            if !flashCardViewShowing {
                ListView(stack: $stack, papersDatabase: papersDatabase)
                    .navigationTitle(stack.title)
            } else {
                FlashCardView(cards: stack.cards)
                    .transition(.opacity)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    withAnimation {
                        flashCardViewShowing.toggle()
                    }
                }){
                    Image(systemName: flashCardViewShowing ? .pauseFill : .playFill)
                        .font(.title2, weight: .bold)
                }
                .foregroundColor(.pink)
            }
        }
        
    }
}

extension FlashCardCollectionView {
    struct ListView: View {
        @State private var newCard: Card = Card.empty
        @Binding var stack: Stack
        
        @ObservedObject var papersDatabase: PapersDatabase
        
        var body: some View {
            List {
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Add a new card")
                                .font(.title3, weight: .bold)
                            
                            Spacer()
                            
                            if !newCard.isEmpty() {
                                SymbolButton("plus.circle.fill"){
                                    withAnimation {
                                        stack.cards.append(newCard.generate())
                                        newCard = Card.empty
                                    }
                                    papersDatabase.saveDeck()
                                }
                                .font(.title, weight: .regular)
                                .foregroundColor(.blue)
                            } else {
                                Image(systemName: .plusCircleFill)
                                    .font(.title, weight: .regular)
                                    .foregroundColor(.blue)
                            }
                            
                        }
                        .padding(.vertical)
                        .opacity(newCard.isEmpty() ? 0.5 : 1)
                        
                        Group {
                            TextField("The prompt / question", text: $newCard.prompt)
                            TextField("The answer", text: $newCard.answer)
                            
                        }
                        .font(.headline, weight: .light)
                        .padding(.vertical, 10)
                        
                    }
                }
                
                ForEach(stack.cards) { card in
                    ItemView(card: card)
                }
                .onDelete(perform: delete)
            }
            .listStyle(.insetGrouped)
        }
    }
}

extension FlashCardCollectionView.ListView {
    struct ItemView: View {
        var card: Card
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(card.prompt)
                    .padding(.bottom, 2)
                Text("\(card.answer)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 10)
        }
    }
    
    func delete(at offsets: IndexSet) {
        stack.cards.remove(atOffsets: offsets)
        papersDatabase.saveDeck()
    }
}

struct FlashCardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack { /// necessary for transitions to work in canvas
                FlashCardCollectionView(stack: .constant(Stack.example), papersDatabase: ApplicationStore().papersDatabase)
            }
        }
    }
}
