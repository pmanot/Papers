//
// Copyright (c) Purav Manot
//


import SwiftUI
import SwiftUIX

struct FlashCardView: View {
    let cards: [Card] = [Card](repeating: Card.example, count: 5)
    var body: some View {
        GeometryReader { screen in
            VStack {
                TabView {
                    ForEach(enumerating: cards){ (i, data) in
                        FlashCard(data)
                            .frame(width: 400, height: 200, alignment: .center)
                            .zIndex(Double(i))
                    }
                }
                .tabViewStyle(.page)
                
                LoadingView()
                    .frame(width: screen.size.width, height: 40)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

extension FlashCardView {
    func calculatedOffset(_ index: Int) -> CGFloat {
        let i = index + 1
        return CGFloat(((cards.count/2) - i))*10
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FlashCardView()
                .preferredColorScheme(.dark)
        }
    }
}


struct LoadingView: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)
    }
}
