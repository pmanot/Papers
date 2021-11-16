//
// Copyright (c) Purav Manot
//

import SwiftUI
import PencilKit

struct DrawingOverlayView: View {
    @State private var canvasView = PKCanvasView()
    @State var rendition: Rendition?
    var body: some View {
        PencilKitCanvasView(canvasView: $canvasView, onSaved: saveDrawing)
    }
}

struct DrawingOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingOverlayView()
    }
}

extension DrawingOverlayView {
    func saveDrawing(){
        let rendition = Rendition("Best drawing", canvasView: self.canvasView)
        self.rendition = rendition
    }
}
