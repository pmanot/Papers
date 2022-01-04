//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct Toolbar: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    let timer = Timer.publish(every: 1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    @State private var timeTaken: TimeInterval = .zero

    @State private var dragOffset: CGSize = .zero
    @State private var minimised: Bool = false
    @State private var testModeEnded: Bool = true
    @State var flashcardCreationSheetShowing: Bool = false
    @State var timerShowing: Bool = false
    @Namespace private var toolbar
    
    @Binding var markschemeShowing: Bool
    @Binding var answerOverlayShowing: Bool
    @Binding var testMode: Bool
    @Binding var datasheetShowing: Bool
    
    var body: some View {
        GeometryReader { screen in
                ToolbarItemsView(minimised: $minimised, testMode: $testMode, timerShowing: $timerShowing, markschemeShowing: $markschemeShowing, answerOverlayShowing: $answerOverlayShowing, datasheetShowing: $datasheetShowing, flashcardCreationSheetShowing: $flashcardCreationSheetShowing)
                    .background(Color.background.cornerRadius(.infinity).border(Color.secondary, cornerRadius: .infinity))
                    .matchedGeometryEffect(id: "1", in: toolbar)
                    .frame(width: !minimised ? 320 : 80, height: !minimised ? 50 : 45)
                    .position(
                        !minimised ? screen.bottom : CGPoint(x: 60, y: testMode ? screen.top.y : screen.bottom.y)
                    )
                    .offset(dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { movement in
                                withAnimation(.spring()) {
                                    dragOffset.width = {
                                        if movement.translation.width > 50 {
                                            minimised = false
                                            return 30
                                        } else if movement.translation.width < -50 {
                                            minimised = true
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
                                        minimised = false
                                    }
                                }
                                if movement.approximateDirection == .left {
                                    withAnimation(.spring()) {
                                        minimised = true
                                    }
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.spring()){
                                    dragOffset = .zero
                                }
                            }
                    )
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

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar(markschemeShowing: .constant(false), answerOverlayShowing: .constant(false), testMode: .constant(true), datasheetShowing: .constant(true))
            .preferredColorScheme(.dark)
            .environmentObject(ApplicationStore())
    }
}


extension Toolbar {
    struct ToolbarItemsView: View {
        @EnvironmentObject var applicationStore: ApplicationStore
        @Environment(\.presentationMode) var presentView
        @Binding var minimised: Bool
        @Binding var testMode: Bool
        @Binding var timerShowing: Bool
        
        @Binding var markschemeShowing: Bool
        @Binding var answerOverlayShowing: Bool
        @Binding var datasheetShowing: Bool
        @Binding var flashcardCreationSheetShowing: Bool
        
        var body: some View {
            HStack {
                if testMode {
                    Button(action: {
                        withAnimation(.spring()) {
                            testMode.toggle()
                            answerOverlayShowing = false
                            minimised = false
                        }
                    }){
                        Image(systemName: .stopCircleFill)
                            .font(.title2)
                    }
                    .frame(width: 30)
                    
                    Button(action: {
                        withAnimation {
                            timerShowing.toggle()
                        }
                    }){
                        Image(systemName: timerShowing ? .stopwatchFill : .stopwatch)
                            .font(.title2)
                    }
                    .frame(width: 30)
                } else {
                    
                    SymbolButton("arrow.left.circle.fill"){
                        presentView.dismiss()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.title)
                    .frame(width: 30)
                    
                    if !minimised {
                        Group {
                            Picker("", selection: $markschemeShowing){
                                Text("QP")
                                    .tag(false)
                                Text("MS")
                                    .tag(true)
                            }
                            .frame(width: 80)
                            .pickerStyle(SegmentedPickerStyle())
                            
                            Button(action: {
                                datasheetShowing.toggle()
                            }){
                                Image(systemName: datasheetShowing ? .docTextFill : .docText)
                                    .font(.title2)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundColor(.primary)
                                            .frame(width: 30, height: 30)
                                            .opacity(datasheetShowing ? 0.1 : 0)
                                    }
                            }
                            .frame(width: 30, height: 30)
                            
                            Spacer()
                            
                            Button(action: {
                                flashcardCreationSheetShowing.toggle()
                            }){
                                Image(systemName: .rectangleStackBadgePlus)
                                    .font(.title2)
                            }
                            .frame(width: 30)
                            
                            SymbolButton("bookmark", onToggle: "bookmark.fill"){
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.title2, weight: .regular)
                            .frame(width: 30)
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    minimised = true
                                    testMode.toggle()
                                    answerOverlayShowing.toggle()
                                    markschemeShowing = false
                                    datasheetShowing = false
                                }
                            }){
                                Image(systemName: .playCircleFill)
                                    .font(.title)
                            }
                        }
                        .transition(.leadCrossDissolve)
                        
                    }
                    
                    
                    if minimised {
                        Group {
                            Button(action: {
                                withAnimation(.spring()){
                                    minimised.toggle()
                                }
                            }){
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .opacity(minimised ? 1 : 0)
                            }
                            .frame(width: 30)
                        }
                        
                    }
                }
                
                
            }
            .foregroundColor(.label)
            .padding(6)
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
