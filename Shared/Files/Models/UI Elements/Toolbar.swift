//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct Toolbar: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    
    @State private var timer = Timer.publish(
        every: 1,
        tolerance: nil,
        on: .main,
        in: .common,
        options: nil
    )
        .autoconnect()
    
    @State private var timeTaken: TimeInterval = .zero
    
    @State private var dragOffset: CGSize = .zero
    @State private var minimized: Bool = true
    @State private var testModeEnded: Bool = true
    @State var flashcardCreationSheetShowing: Bool = false
    @State var timerShowing: Bool = false
    @Namespace private var toolbar
    
    @Binding var markschemeShowing: Bool
    @Binding var answerOverlayShowing: Bool
    @Binding var paperSelection: CambridgePaperType
    @Binding var testMode: Bool
    @Binding var datasheetShowing: Bool
    
    var body: some View {
        GeometryReader { screen in
            let toolbarGesture = DragGesture()
                .onChanged { movement in
                    withAnimation(.spring()) {
                        dragOffset.width = {
                            if movement.translation.width > 50 {
                                minimized = false
                                return 30
                            } else if movement.translation.width < -50 {
                                minimized = true
                                return -30
                            } else {
                                return movement.translation.width
                            }
                        }()
                        
                        dragOffset.height = {
                            if movement.translation.height > 40 {
                                return 40
                            } else if movement.translation.height < -40 {
                                return -40
                            } else {
                                return movement.translation.height
                            }
                        }()
                    }
                    
                    if movement.approximateDirection == .right {
                        withAnimation(.spring()) {
                            minimized = false
                        }
                    }
                    if movement.approximateDirection == .left {
                        withAnimation(.spring()) {
                            minimized = true
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring()){
                        dragOffset = .zero
                    }
                }
            
            ZStack {
                Color.primaryInverted.cornerRadius(.infinity)
                
                ItemsView(minimized: $minimized, testMode: $testMode, timerShowing: $timerShowing, paperSelection: $paperSelection, markschemeShowing: $markschemeShowing, answerOverlayShowing: $answerOverlayShowing, datasheetShowing: $datasheetShowing, flashcardCreationSheetShowing: $flashcardCreationSheetShowing)
            }
            .matchedGeometryEffect(id: "t", in: toolbar)
            .frame(width: !minimized ? 320 : 80, height: !minimized ? 50 : 45)
            .position(
                !minimized ? screen.bottom : CGPoint(x: 60, y: testMode ? screen.top.y : screen.bottom.y)
            )
            .offset(dragOffset)
            .gesture(toolbarGesture)
            
            if timerShowing {
                Text("\(timeTaken.timeComponents().1) : \(timeTaken.timeComponents().2)")
                    .font(.subheadline, weight: .bold)
                    .padding(10)
                    .background(Color.background)
                    .border(Color.secondary, cornerRadius: .infinity)
                    .position(CGPoint(x: screen.size.width - 40, y: screen.top.y))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $flashcardCreationSheetShowing){
            FlashCardCreationView(showing: $flashcardCreationSheetShowing)
        }
        .onReceive(timer){ _ in
            if testMode {
                timeTaken += 1
            }
        }
    }
}

extension Toolbar {
    
    var timerView: some View {
        HStack {
            HStack( spacing: 2) {
                Text("\(timeTaken.timeComponents().0)")
                    .font(.title3, weight: .bold)
                Text("hours, ")
                    .font(.caption, weight: .light)
            }
            
            
            HStack( spacing: 2) {
                Text("\(timeTaken.timeComponents().1)")
                    .font(.title3, weight: .bold)
                Text("minutes, ")
                    .font(.caption, weight: .light)
            }
            
            HStack( spacing: 2) {
                Text("\(timeTaken.timeComponents().2)")
                    .font(.title3, weight: .bold)
                Text("seconds")
                    .font(.caption, weight: .light)
            }
        }
        .padding(5)
        .background(BlurEffectView(style: .systemUltraThinMaterial))
        .border(Color.secondary, cornerRadius: 10)
    }
}

// MARK: - Development Preview -

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar(markschemeShowing: .constant(false), answerOverlayShowing: .constant(false), paperSelection: .constant(.questionPaper), testMode: .constant(false), datasheetShowing: .constant(false))
            .preferredColorScheme(.dark)
            .environmentObject(ApplicationStore())
    }
}
