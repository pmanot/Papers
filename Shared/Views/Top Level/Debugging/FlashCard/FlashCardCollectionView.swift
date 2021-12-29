//
//  FlashCardCollectionView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 29/12/21.
//

import SwiftUI

struct FlashCardCollectionView: View {
    @Binding var stack: Stack
    @State private var creationSheetIsShowing: Bool = false
    @State private var flashCardView: Bool = false
    @State private var newCard: Card = Card.empty
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Add a new card")
                            .font(.title3, weight: .bold)
                        
                        Spacer()
                        
                        SymbolButton("plus.circle.fill"){
                            
                        }
                        .font(.title2, weight: .regular)
                        .foregroundColor(.blue)
                    }
                    .padding(.top, 15)
                    .opacity(newCard.isEmpty() ? 0.5 : 1)
                    
                    Line()
                        .stroke()
                        .opacity(newCard.isEmpty() ? 0.5 : 1)
                    
                    TextField("The prompt / question", text: $newCard.prompt)
                        .font(.headline, weight: .regular)
                        .padding()
                    TextField("The answer", text: $newCard.answer)
                        .font(.headline, weight: .regular)
                        .padding()
                }
                
                
            }
            
            ForEach(stack.cards) { card in
                ItemView(card: card)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(stack.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                SymbolButton("play.circle.fill"){
                    flashCardView.toggle()
                }
                .font(.title2, weight: .bold)
                .foregroundColor(.pink)
            }
        }
        .sheet(isPresented: $creationSheetIsShowing){
            FlashCardCreationView(stack: $stack, showing: $creationSheetIsShowing)
        }
        .sheet(isPresented: $flashCardView){
            FlashCardView(cards: stack.cards)
        }
    }
}

extension FlashCardCollectionView {
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
            FlashCardCollectionView(stack: .constant(Stack.example))
        }
    }
}
