//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct TestCrop: View {
    let pdf = PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9701_m20_qp_42", ofType: "pdf")!))!
    var body: some View {
        ScrollView {
            VStack {
                ForEach(1..<(pdf.pageCount - 1)){ i in
                    Image(cgImage: pdf.page(at: i)!.snapshot().cgImage!.cropping(to: CGRect(origin: CGPoint(x: 50, y: 0), size: CGSize(width: 100, height: 1000)))!)
                        .resizable()
                        .border(Color.black)
                        .scaleEffect(0.10, anchor: .center)
                        .scaledToFill()
                    
                }
            }
        }
    }
}

struct TestCrop_Previews: PreviewProvider {
    static var previews: some View {
        TestCrop()
    }
}


