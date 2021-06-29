//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct PdfView: View {
    @Environment(\.colorScheme) var colorScheme
    var pdf: PDFDocument
    var pages: [Int] = [3]
    
    var body: some View {
        GeometryReader { screen in
            ScrollView {
                VStack {
                    ForEach(pages, id: \.self) { page in
                        Group {
                            if colorScheme == .dark {
                                CustomPDFView(pdf, page: page)
                                    .colorInvert()
                            } else {
                                CustomPDFView(pdf, page: page)
                            }
                        }
                        .frame(width: screen.size.width, height: screen.size.height)
                    }
                }
                .background(colorScheme == .dark ? Color.black : Color.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    init(_ paper: Paper, pages: [Int]){
        self.pdf = paper.pdf
        self.pages = pages
    }
    
    init(_ markScheme: MarkScheme, pages: [Int]){
        self.pdf = markScheme.pdf
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
    let pdfView = PDFView()
    
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
        pdfView.displayBox = .artBox
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        pdfView.backgroundColor = UIColor(Color.primary == .white ? .black : .white)
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
        pdfView.displayBox = .trimBox
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
