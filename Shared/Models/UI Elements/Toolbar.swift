//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct Toolbar: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    @State private var dragOffset: CGSize = .zero
    @State private var minimised: Bool = false
    @Binding var markschemeToggle: Bool
    @Namespace private var toolbar
    
    var body: some View {
        GeometryReader { screen in
            ZStack(alignment: .leading) {
                Capsule()
                    .foregroundColor(.black)
                    .matchedGeometryEffect(id: "1", in: toolbar)
                    .frame(height: !minimised ? 50 : 45)
                    .position(!minimised ? screen.bottom : CGPoint(x: 60, y: screen.bottom.y))
                ToolbarItemsView(minimised: $minimised, markschemeShowing: $markschemeToggle)
                    .position(!minimised ? screen.bottom : CGPoint(x: 60, y: screen.bottom.y))

            }
            .width(!minimised ? 320 : 80)
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
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar(markschemeToggle: .constant(true))
            .environmentObject(ApplicationStore())
    }
}

extension GeometryProxy {
    var center: CGPoint {
        CGPoint(x: self.size.width/2, y: self.size.height/2)
    }
    
    var bottom: CGPoint {
        CGPoint(x: self.size.width/2, y: self.size.height - 40)
    }
}


extension Toolbar {
    struct ToolbarItemsView: View {
        @EnvironmentObject var applicationStore: ApplicationStore
        @Environment(\.presentationMode) var presentView
        @Binding var minimised: Bool
        @Binding var markschemeShowing: Bool
        
        init(minimised: Binding<Bool>, markschemeShowing: Binding<Bool>){
            self._minimised = minimised
            self._markschemeShowing = markschemeShowing
            
            UISegmentedControl.appearance().backgroundColor = .clear
            UISegmentedControl.appearance().tintColor = .white
            UISegmentedControl.appearance().selectedSegmentTintColor = .white
        }
        
        var body: some View {
            HStack {
                SymbolButton("arrow.left.circle.fill"){
                    presentView.dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                .font(.title)
                .width(30)
                
                if !minimised {
                    
                    Picker("", selection: $markschemeShowing){
                        Image(systemName: !markschemeShowing ? "doc.text.fill" : "doc.text").tag(false)
                        Image(systemName: markschemeShowing ? "doc.on.doc.fill" : "doc.on.doc").tag(true)
                    }
                    .width(80)
                    .background(Color.white.cornerRadius(8))
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                    
                    SymbolButton("bookmark", onToggle: "bookmark.fill"){
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.white)
                    .font(.title2, weight: .semibold)
                    .width(30)
                }
                
                if minimised {
                    Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .font(.title2)
                    .width(30)
                    .opacity(minimised ? 1 : 0)
                    .onLongPressGesture(minimumDuration: 0.01) {
                        withAnimation(.spring()){
                            minimised.toggle()
                        }
                    }
                }
            }
            .padding(6)
        }
    }
}
