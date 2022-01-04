//
// Copyright (c) Purav Manot
//

import PDFKit
import Swift

extension PDFPage {
    public func snapshot() -> UIImage {
        let pageRect = bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)

        print("WHAT THE FUCK", pageRect)

        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            ctx.cgContext.translateBy(x: 0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1, y: -1.0)
            ctx.cgContext.stroke(pageRect)
            
            ctx.cgContext.drawPDFPage(pageRef!)
        }
        
        return img
    }
}

func getImagefromURL(url: URL, pageNumber: Int) -> UIImage? {
    guard let document = CGPDFDocument(url as CFURL) else { return nil }
    guard let page = document.page(at: pageNumber) else { return nil }

    let pageRect = page.getBoxRect(.mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
    let img = renderer.image { ctx in
        UIColor.white.set()
        ctx.fill(pageRect)

        ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
        ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

        ctx.cgContext.drawPDFPage(page)
    }

    return img
}
