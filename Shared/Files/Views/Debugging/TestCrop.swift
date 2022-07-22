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

    @State var completeText: String = ""

    let pdf = PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s19_ms_12", ofType: "pdf")!))!
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(1..<pdf.pageCount) { i in
                        Image(uiImage: pdf.page(at: i)!.snapshot())
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                /*
                                Text(pdf.page(at: i)!.string!.fetchAnswers().joined(separator: ","))
                                    .font(.caption2)
                                    .opacity(0.5)
                                */
                            }
                            .border(Color.black)
                        
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
        .task {
            try! await computeCompleteText()
        }
    }

    @MainActor
    func computeCompleteText() async throws {
        var t: String = ""
        let pdfPageSnapshot = pdf.page(at: 1)!.snapshot().cgImage!
        for n in 0..<28 {
            t += try await recognizeAllText(from: pdfPageSnapshot.cropping(to: CGRect(origin: CGPoint(x: 230, y: 177 + 49*n), size: CGSize(width: 74, height: 45)))!, .accurate, lookFor: ["A", "B", "C", "D"])
            t += " "
        }
        completeText = t
    }
}

struct TestCrop_Previews: PreviewProvider {
    static var previews: some View {
        TestCrop()
    }
}





