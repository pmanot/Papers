//
//  FlashCardCollectionView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 29/12/21.
//

import SwiftUI

struct FlashCardCollectionView: View {
    @Binding var stack: Stack
    @State private var flashCardViewShowing: Bool = false
    
    var body: some View {
        Group {
            if !flashCardViewShowing {
                ListView(stack: $stack)
                .navigationTitle(stack.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        SymbolButton("play.circle.fill"){
                            withAnimation {
                                flashCardViewShowing.toggle()
                            }
                        }
                        .font(.title2, weight: .bold)
                        .foregroundColor(.pink)
                        .transition(.opacity)
                    }
                }
            } else {
                FlashCardView(cards: stack.cards)
                    .transition(.opacity)
            }
        }
        
    }
}

extension FlashCardCollectionView {
    struct ListView: View {
        @Binding var stack: Stack
        @State private var newCard: Card = Card.empty
        
        var body: some View {
            List {
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Add a new card")
                                .font(.title3, weight: .regular)
                            
                            Spacer()
                            
                            SymbolButton("plus.circle.fill"){
                                withAnimation {
                                    stack.cards.append(newCard.generate())
                                    newCard = Card.empty
                                }
                            }
                            .font(.title2, weight: .regular)
                            .foregroundColor(.blue)
                        }
                        .padding(10)
                        .padding(.top, 5)
                        .opacity(newCard.isEmpty() ? 0.5 : 1)
                        
                        Line()
                            .stroke()
                            .opacity(newCard.isEmpty() ? 0.5 : 1)
                        
                        Group {
                            TextField("The prompt / question", text: $newCard.prompt)
                            TextField("The answer", text: $newCard.answer)
                        }
                        .font(.headline, weight: .light)
                        .padding(10)
                        
                    }
                }
                
                ForEach(stack.cards) { card in
                    ItemView(card: card)
                }
                .onDelete(perform: delete)
            }
        }
    }
}

extension FlashCardCollectionView.ListView {
    struct ItemView: View {
        var card: Card
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(card.prompt)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Text("\(card.answer)")
                    .font(.subheadline, weight: .light)
                    .multilineTextAlignment(.leading)
            }
            .frame(height: 100)
        }
    }
    
    func delete(at offsets: IndexSet) {
        stack.cards.remove(atOffsets: offsets)
    }
}

struct FlashCardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack { /// necessary for transitions to work in canvas
                FlashCardCollectionView(stack: .constant(Stack.example))
            }
        }
    }
}
