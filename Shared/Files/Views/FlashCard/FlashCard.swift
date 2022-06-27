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
        GeometryReader { screen in
            VStack(alignment: .leading) {
                Text(card.prompt)
                    .font(flipped ? .title2 : .title, weight: .heavy)
                    .foregroundColor(flipped ? .secondary : .white)
                    .padding(5)
                
                Text(card.answer)
                    .font(flipped ? .title2 : .title3, weight: .bold)
                    .foregroundColor(flipped ? .white : .secondary)
                    .onAppear(perform: stopBlink)
                    .padding(5)
                    .blur(radius: flipped ? 0 : 5)
                    .opacity(flipped ? 1 : 0.5)
                
            }
            .frame(width: screen.size.width, height: screen.size.height)
            .position(x: screen.size.width/2, y: screen.size.height/2)
            .background(Color.accentColor.edgesIgnoringSafeArea(.all))
            .onTapGesture {
                withAnimation(.spring()){
                    self.flipped.toggle()
                }
            }
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
