//
//  PartialSheet.swift
//  Papers
//
//  Created by Purav Manot on 18/07/21.
//

import SwiftUI

struct PartialSheet<Content: View>: View {
    @State private var dragOffset: CGFloat = 0
    @State private var yPos: CGFloat = 0
    @State private var customHeight: CGFloat = 0
    
    @Binding var isPresented: Bool
    let height: SheetHeight
    var destination: () -> Content
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        GeometryReader { screen in
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(.black)
                    .shadow(radius: 2)
                    .overlay(destination())
                    .position(x: screen.size.width/2, y: yPos + dragOffset)
                    .frame(width: screen.size.width, height: customHeight)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.dragOffset = gesture.translation.height
                            }
                            .onEnded { gesture in
                                self.dragOffset = gesture.translation.height
                                withAnimation(.spring()) {
                                    if gesture.predictedEndTranslation.height < -customHeight/4 {
                                        yPos = screen.size.height - customHeight/2
                                        print("I'm back!")
                                    }
                                    if gesture.predictedEndTranslation.height > customHeight/4 {
                                        yPos = screen.size.height + customHeight/2
                                        print("sheet disappeared")
                                    }
                                    dragOffset = 0
                                }
                            }
                    )
                .onAppear {
                    customHeight = screen.size.height*height.rawValue
                    yPos = screen.size.height + customHeight/2
                }
                .onChange(of: isPresented, perform: { value in
                    switch value {
                    case true:
                        withAnimation(.spring()) {
                            yPos = screen.size.height - customHeight/2
                        }
                    case false:
                        withAnimation(.spring()) {
                            yPos = screen.size.height + customHeight/2
                        }
                    }
                })
            }
        }
        .disabled(!isPresented)
    }
}

enum SheetHeight: CGFloat {
    case full = 1
    case half = 0.5
    case small = 0.25
    case toolbar = 0.15
}
