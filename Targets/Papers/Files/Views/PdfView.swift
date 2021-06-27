//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct PdfView: View {
    var paper: Paper = Paper.example
    var pages: [Int] = [3]
    
    var body: some View {
        GeometryReader { screen in
            VStack {
                ScrollView {
                    ForEach(pages, id: \.self) { page in
                        CustomPDFView(pdf: paper.pdf, page: page)
                            .frame(width: screen.size.width, height: screen.size.height)
                    }
                }
            }
        }
    }
    
    init(_ paper: Paper, pages: [Int]){
        self.paper = paper
        self.pages = pages
    }
}

struct PdfView_Previews: PreviewProvider {
    static var previews: some View {
        PdfView(Paper.example, pages: [4])
    }
}

struct CustomPDFView: UIViewRepresentable {
    let pdf: PDFDocument
    let page: Int
    init(pdf: PDFDocument, page: Int = 3){
        self.pdf = pdf
        self.page = page
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomPDFView>) -> CustomPDFView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = pdf
        pdfView.autoScales = true
        pdfView.go(to: pdf.page(at: page)!)
        pdfView.displayMode = .singlePage
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct CustomPDFEditor: UIViewRepresentable {
    let pdfView = PDFView()
    let pdf: PDFDocument
    init(pdf: PDFDocument){
        self.pdf = pdf
    }
    
    func makeUIView(context: Context) -> UIView {
        pdfView.document = pdf
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
