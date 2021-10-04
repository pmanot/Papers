//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct CustomPDFView: UIViewRepresentable {
    let pdf: PDFDocument
    let page: Int
    let pdfView = PDFKit.PDFView()
    
    init(_ pdf: PDFDocument, page: Int = 3){
        self.pdf = pdf
        self.page = page
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomPDFView>) -> CustomPDFView.UIViewType {
        
        pdfView.document = pdf
        pdfView.autoScales = true
        pdfView.go(to: pdf.page(at: page)!)
        pdfView.displayMode = .singlePage
        pdfView.displaysPageBreaks = false
        pdfView.pageShadowsEnabled = false
        pdfView.displayBox = .cropBox
        pdfView.backgroundColor = UIColor.clear
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct CustomPDFEditor: UIViewRepresentable {
    let pdfView = PDFKit.PDFView()
    let pdf: PDFDocument
    init(pdf: PDFDocument){
        self.pdf = pdf
    }
    
    func makeUIView(context: Context) -> UIView {
        pdfView.document = pdf
        pdfView.autoScales = true
        pdfView.displayBox = .trimBox
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
