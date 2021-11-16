//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX
import PencilKit

struct Rendition {
    let title: String
    let drawing: PKDrawing
    let image: Image
    
    
    init(_ title: String, canvasView: PKCanvasView){
        self.title = title
        self.drawing = canvasView.drawing
        self.image = Image(uiImage: canvasView.drawing.image(from: canvasView.bounds, scale: Screen.main.scale))
    }
}


