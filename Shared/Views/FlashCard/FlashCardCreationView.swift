//
//  FlashCardCreationView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 27/12/21.
//

import SwiftUI

struct FlashCardCreationView: View {
    @Binding var stack: Stack
    @State private var card = Card.empty
    @State var keyword: String = ""
    @Binding var isShowing: Bool
    
    init(stack: Binding<Stack>, showing: Binding<Bool>){
        self._stack = stack
        self._isShowing = showing
    }
    var body: some View {
        VStack(alignment: .center) {
            Spacer(minLength: 40)
            
            VStack(alignment: .leading, spacing: 15) {
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
            
            Button(action: save){
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
    func save(){
        if !card.isEmpty() {
            stack.cards.append(card.generate())
            card = Card.empty
        }
        
        self.isShowing.toggle()
    }
}

struct FlashCardCreationView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardCreationView(stack: .constant(Stack.empty), showing: .constant(true))
    }
}
