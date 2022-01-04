//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct TestCrop: View {
    @State var cropWidth: CGFloat = 10
    @State var cropHeight: CGFloat = 10
    @State var x: CGFloat = 0
    @State var number: CGFloat = 0
    var completeText: String {
        var t: String = ""
        for n in 0..<28 {
            t +=
            recogniseAllText(from: pdf.page(at: 1)!.snapshot().cgImage!.cropping(to: CGRect(origin: CGPoint(x: 230, y: 177 + 49*n), size: CGSize(width: 74, height: 45)))!, .accurate, lookFor: ["A", "B", "C", "D"])
            t += " "
        }
        return t
    }
    let pdf = PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_qp_42", ofType: "pdf")!))!
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(1..<(pdf.pageCount)){ i in
                        Image(uiImage: pdf.page(at: i)!.thumbnail(of: CGSize(width: pdf.page(at: i)!.bounds(for: .mediaBox).size.width, height: pdf.page(at: i)!.bounds(for: .mediaBox).size.height), for: .mediaBox))
                            .resizable()
                            .overlay {
                                VStack {
                                    Image(cgImage: pdf.page(at: i)!.thumbnail(of: CGSize(width: pdf.page(at: i)!.bounds(for: .mediaBox).size.width, height: pdf.page(at: i)!.bounds(for: .mediaBox).size.height), for: .mediaBox).cgImage!.cropping(to: CGRect(origin: CGPoint(x: 20, y: 30), size: CGSize(width: 50, height: 70)))!)
                                        .border(Color.black)
                                }
                            }
                            .border(Color.black)
                            .scaledToFill()
                        
                    }
                }
            }
            Slider(value: $number, in: 0...28, step: 1)
                .padding(5)
            Text("number: \(number)")
            Slider(value: $x, in: 0...1000, step: 1)
                .padding(5)
            Text("x: \(x)")
            Slider(value: $cropWidth, in: 10...CGFloat(pdf.page(at: 1)!.snapshot().cgImage!.width), step: 1)
                .padding(5)
            Text("cropWidth: \(cropWidth)")
            Slider(value: $cropHeight, in: 10...CGFloat(pdf.page(at: 1)!.snapshot().cgImage!.height), step: 1)
                .padding(5)
            Text("cropHeight: \(cropHeight)")
        }
    }
}

struct TestCrop_Previews: PreviewProvider {
    static var previews: some View {
        TestCrop()
    }
}


