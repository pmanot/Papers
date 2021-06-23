//
//  PdfView.swift
//  Papers
//
//  Created by Purav Manot on 21/06/21.
//

import SwiftUI
import UniformTypeIdentifiers
import PDFKit
import Filesystem



struct PdfView: View {
    @State var pdf = PDFFileDocument(pdf: PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s19_qp_21", ofType: "pdf")!))!)
    var pages: [Int]
    
    init(_ pdf: PDFDocument = PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s19_qp_21", ofType: "pdf")!))!, pages: Pages = .index(3)){
        self.pdf = PDFFileDocument(pdf: pdf)
        switch pages {
            case .index(let x):
                self.pages = [x]
                
            case .all:
                self.pages = Array(0..<pdf.pageCount)
        }
    }
    
    init(_ url: URL, pages: Pages = .index(3)){
        self.pdf = PDFFileDocument(pdf: PDFDocument(url: url)!)
        switch pages {
            case .index(let x):
                self.pages = [x]
                
            case .all:
                self.pages = Array(0..<PDFFileDocument(pdf: PDFDocument(url: url)!).pdf.pageCount)
        }
    }
    
    
    var body: some View {
        VStack {
            ScrollView {
                Spacer()
                ForEach(pages, id: \.self){ page in
                    drawPDF(pdf: pdf.pdf, page: page)
                        .frame(width: 500, height: 500)
                        .scaleEffect(CGSize(width: 0.65, height: 0.65))
                        .drawingGroup()
                        .id(UUID())
                }
                Spacer()
            }
        }
    }
}

struct PdfView_Previews: PreviewProvider {
    static var previews: some View {
        PdfView()
    }
}


func drawPDF(pdf: PDFDocument, page: Int = 1) -> Image? {
    guard let page = pdf.page(at: page) else { return nil }

    let pageRect = page.bounds(for: .mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
    let img = renderer.image { ctx in
        UIColor.white.set()
        ctx.fill(pageRect)
        ctx.cgContext.translateBy(x: 0, y: pageRect.size.height)
        ctx.cgContext.scaleBy(x: 1, y: -1.0)
        ctx.cgContext.stroke(pageRect)

        ctx.cgContext.drawPDFPage(page.pageRef!)
    }

    return Image(uiImage: img)
}

enum Pages {
    case all
    case index(_ x: Int)
}
