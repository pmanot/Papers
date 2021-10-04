//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct WrappedPDFView: UIViewRepresentable {
    let pdfView = PDFKit.PDFView()
    let pdf: PDFDocument
    
    class Coordinator: NSObject, PDFViewDelegate {
        var parent: WrappedPDFView
        
        init(_ parent: WrappedPDFView){
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    init(pdf: PDFDocument){
        self.pdf = pdf
    }
    
    init(pages: [PDFPage]){
        let compiledPDF = PDFDocument()
        for page in pages.reversed() {
            compiledPDF.insert(page, at: 0)
        }
        self.pdf = compiledPDF
    }
    
    func makeUIView(context: Context) -> UIView {
        pdfView.document = pdf
        pdfView.autoScales = true
        pdfView.displayBox = .mediaBox
        pdfView.delegate = context.coordinator
        pdfView.pageShadowsEnabled = true
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct PDFView: View {
    let pdf: PDFDocument
    @State var drawingOverlay: Bool = false
    
    init(_ pdf: PDFDocument){
        self.pdf = pdf
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            WrappedPDFView(pdf: pdf)
                .isScrollEnabled(true)
            if drawingOverlay {
                DrawingOverlayView()
                    .scrollDisabled(true)
            }
        }
        .navigationBarItems(leading:
            SymbolButton("pencil.circle"){
                drawingOverlay.toggle()
            }
        )
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFView(PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9701_m20_qp_42", ofType: "pdf")!))!)
    }
}
