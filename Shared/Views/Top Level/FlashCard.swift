//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct FlashCard: View {
    @State private var colors = [Color](repeating: Color.gray, count: 20)
    @State private var count = 0
    private let timer = Timer.publish(every: 0.02, on: .current, in: .common, options: nil).autoconnect()

    let card: Card
    
    init(_ card: Card){
        self.card = card
    }
    
    @State private var flipped: Bool = false
    @State private var blink: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(card.prompt)
                .font(.title3, weight: .bold)
                .foregroundColor(flipped ? .secondary : .primary)
                .onAppear(perform: startBlink)
                .padding(5)
            
            if flipped {
                Text(card.answer)
                    .font(.headline, weight: .bold)
                    .onAppear(perform: stopBlink)
                    .padding(5)
                    .transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .opacity))
            }
        }
        .frame(width: 350, height: 180, alignment: .center)
        .border(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing), width: 1, cornerRadius: 10, antialiased: true)
        .background {
            cardView
        }
        .onTapGesture {
            self.isTapped()
        }
        .onReceive(timer){ _ in
            timerRecieved()
        }
    }
}

extension FlashCard {
    private func isTapped() {
        withAnimation(.easeInOut(duration: 1)) {
            colors = [Color](repeating: Color.gray, count: 2) + [Color](repeating: Color.white, count: 5) + [Color](repeating: Color.gray, count: 2) + [Color](repeating: Color.gray, count: 20)
            count = 0
            withAnimation {
                flipped.toggle()
            }
        }
    }
    
    private func timerRecieved() {
        if count != 20 {
            colors.rotate()
            count += 1
        } else {
            colors = [Color](repeating: Color.gray, count: 20)
        }
    }
    
    private func startBlink() {
        withAnimation(.linear(duration: 2).repeat(while: !flipped)){
            blink.toggle()
        }
    }
    
    private func stopBlink() {
        withAnimation {
            blink = false
        }
    }
    
    private var cardView: some View {
        ZStack(alignment: .bottom) {
            BlurEffectView(style: .systemUltraThinMaterial)
                .cornerRadius(10)
            Text("tap to reveal answer")
                .font(.caption, weight: .light)
                .padding()
                .opacity(blink ? 0.5 : 0)
        }
        .frame(width: 350, height: 180, alignment: .center)
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FlashCard(Card.example)
                .preferredColorScheme(.dark)
        }
    }
}
