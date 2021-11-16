//
// Copyright (c) Purav Manot
//

import SwiftUI
import PencilKit

struct PencilCanvasView: View {
    @State private var canvasView = PKCanvasView()
    @State var rendition: Rendition?
    var body: some View {
        PencilKitCanvasView(canvasView: $canvasView, onSaved: saveDrawing)
    }
}

struct PencilCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        PencilCanvasView()
    }
}

extension PencilCanvasView {
    func saveDrawing(){
        let rendition = Rendition("Best drawing", canvasView: self.canvasView)
        self.rendition = rendition
    }
}
