//
// Copyright (c) Purav Manot
//


import SwiftUI
import SwiftUIX

struct FlashCardView: View {
    let cards: [Card]
    @State private var currentIndex: Int = 0
    @State private var progressionPercentage: CGFloat = 0
    var body: some View {
        GeometryReader { screen in
            VStack(alignment: .leading) {
                TabView(selection: $currentIndex) {
                    ForEach(enumerating: cards){ (index, data) in
                        FlashCard(data)
                            .frame(width: 400, height: 200, alignment: .center)
                            .tag(Int(index))
                    }
                }
                .tabViewStyle(.page)
                
                LoadingView(percentage: progressionPercentage, in: screen)
                    .foregroundColor(.pink)
                    .frame(height: 30)
                    .onChange(of: currentIndex){ _ in
                        calculateProgress()
                    }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

extension FlashCardView {
    func calculatedOffset(_ index: Int) -> CGFloat {
        let i = index + 1
        return CGFloat(((cards.count/2) - i))*10
    }
    
    func calculateProgress() {
        withAnimation {
            progressionPercentage = CGFloat(currentIndex + 1)/CGFloat(cards.count)
        }
    }
    
    struct LoadingView: View {
        var progress: CGFloat
        let screen: GeometryProxy
        
        init(percentage: CGFloat, in screen: GeometryProxy){
            self.screen = screen
            self.progress = percentage
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: screen.size.width*progress)
            }
        }
    }
    
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FlashCardView(cards: Card.exampleDeck)
        }
    }
}
