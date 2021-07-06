//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct PDFPageView: View {
    @Environment(\.colorScheme) var colorScheme
    let pdf: PDFDocument
    let pages: [Int]
    
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
    
    init(_ paper: QuestionPaper, pages: [Int] = []){
        self.pdf = paper.pdf
        if pages == [] {
            self.pages = Array(0..<paper.pdf.pageCount)
        } else {
            self.pages = pages
        }
    }
    
    init(markScheme: MarkScheme, pages: [Int] = []){
        self.pdf = markScheme.pdf
        if pages == [] {
            self.pages = Array(0..<markScheme.pdf.pageCount)
        } else {
            self.pages = pages
        }
    }
}

struct PDFPageView_Previews: PreviewProvider {
    static var previews: some View {
        PDFPageView(QuestionPaper.example, pages: [4])
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
        pdfView.displayBox = .cropBox
        pdfView.backgroundColor = UIColor.clear
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
        pdfView.displayBox = .trimBox
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
