//
// Copyright (c) Purav Manot
//

import SwiftUI
import PencilKit

struct PencilKitCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @State var toolPicker = PKToolPicker()
    let onSaved: () -> Void
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 10)
        canvasView.backgroundColor = .clear
        canvasView.delegate = context.coordinator
        #if targetEnvironment(simulator)
            canvasView.drawingPolicy = .anyInput
        #endif
        showToolPicker()
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var canvasView: Binding<PKCanvasView>
        let onSaved: () -> Void
        
        init(_ canvasView: Binding<PKCanvasView>, onSaved: @escaping () -> Void ) {
            self.canvasView = canvasView
            self.onSaved = onSaved
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            if !canvasView.drawing.bounds.isEmpty {
                onSaved()
            }
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($canvasView, onSaved: onSaved)
    }
    
    typealias UIViewType = PKCanvasView
    
    func showToolPicker(){
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
}
