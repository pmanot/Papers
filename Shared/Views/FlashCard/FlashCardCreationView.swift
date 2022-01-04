//
//  FlashCardCreationView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 27/12/21.
//

import SwiftUI

struct FlashCardCreationView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    @State private var selectedStackIndex = 0
    @State private var card = Card.empty
    @State var keyword: String = ""
    @Binding var isShowing: Bool
    
    init(showing: Binding<Bool>){
        self._isShowing = showing
    }
    var body: some View {
        VStack(alignment: .center) {
            Spacer(minLength: 40)
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Save in")
                    Picker("", selection: $selectedStackIndex){
                        ForEach(enumerating: applicationStore.papersDatabase.deck){ (index, stack) in
                            Text(stack.title)
                                .tag(Int(index))
                        }
                    }
                    .padding(5)
                }
                Text("Prompt")
                    .font(.title, weight: .heavy)
                TextField("This is where your prompt goes", text: $card.prompt)
                    .font(.subheadline, weight: .regular)
                    .padding()
                    .border(Color.secondary, cornerRadius: 10)
            
                Text("Answer:")
                    .font(.title, weight: .heavy)
                TextField("The Answer", text: $card.answer)
                    .font(.subheadline, weight: .regular)
                    .padding()
                    .border(Color.secondary, cornerRadius: 10)
            }
            
            Spacer(minLength: 20)
            
            VStack(alignment: .leading) {
                Text("Add keywords:")
                    .font(.title2, weight: .heavy)
                TextField("Add keywords required in answer", text: $keyword)
                    .font(.subheadline, weight: .regular)
            }
            
            Spacer(minLength: 20)
            
            Button(action: {save(database: applicationStore.papersDatabase)}){
                Image(systemName: card.isEmpty() ? .chevronDownCircleFill : .checkmarkCircleFill)
                    .font(.largeTitle)
                    .padding()
            }
            
            Spacer(minLength: 20)
        }
        .padding(.horizontal)
    }
}

extension FlashCardCreationView {
    func save(database: PapersDatabase){
        var deck = database.deck
        if !card.isEmpty() {
            deck[selectedStackIndex].cards.append(card)
            database.deck = deck
            card = Card.empty
            database.saveDeck()
        }
        
        self.isShowing.toggle()
    }
}

struct FlashCardCreationView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardCreationView(showing: .constant(true))
    }
}
