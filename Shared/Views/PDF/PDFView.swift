//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct WrappedPDFView: UIViewRepresentable {
    let pdfView = PDFKit.PDFView()
    let pdf: PDFDocument
    
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
    
    init(pdf: PDFDocument, pages: [CambridgePaperPage]){
        self.init(pages: pages.map { $0.getPage(pdf: pdf) })
    }
    
    
    func makeUIView(context: Context) -> UIView {
        pdfView.document = pdf
        pdfView.autoScales = true
        pdfView.displayBox = .mediaBox
        pdfView.backgroundColor = .clear
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        pdfView.document = pdf
    }
}

struct PDFView: View {
    let pdf: PDFDocument
    @State var drawingOverlay: Bool = false
    
    init(_ pdf: PDFDocument){
        self.pdf = pdf
    }
    
    var body: some View {
        ZStack {
            WrappedPDFView(pdf: pdf)
        }
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFView(PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_qp_42", ofType: "pdf")!))!)
    }
}
