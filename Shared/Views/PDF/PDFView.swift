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
    @EnvironmentObject var applicationStore: ApplicationStore
    
    @State var answerOverlayShowing: Bool = false
    @State var markschemeShowing: Bool = false
    @State var datasheetShowing: Bool = false
    @State var testMode = false
    
    let bundle: CambridgePaperBundle
    
    var initialPaperShowing: CambridgePaperType
    
    init(bundle: CambridgePaperBundle, initialPaperShowing: CambridgePaperType = .questionPaper){
        self.bundle = bundle
        self.initialPaperShowing = initialPaperShowing
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Group {
                    // Question paper
                    WrappedPDFView(pdf: bundle.questionPaper!.pdf)
                        .zIndex(calculatedQuestionPaperIndex())
                    
                    // Marking scheme
                    if !bundle.markScheme.isNil {
                        WrappedPDFView(pdf: bundle.markScheme!.pdf)
                            .zIndex(calculatedMarkschemeIndex())
                    }
                    
                    // Data sheet
                    if !bundle.datasheetBySubject.isNil {
                        WrappedPDFView(pdf: bundle.datasheetBySubject!)
                            .zIndex(calculatedDatasheetIndex())
                    }
                    
                }
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                
                Toolbar(markschemeShowing: $markschemeShowing, answerOverlayShowing: $answerOverlayShowing, testMode: $testMode, datasheetShowing: $datasheetShowing)
                    .zIndex(3)
            }
            
            if canShowMCQAnswerOverlay() {
                MCQAnswerOverlay(bundle: bundle, showing: $answerOverlayShowing)
                    .zIndex(4)
                    .transition(.slide)
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            switch initialPaperShowing {
                case .markScheme:
                    markschemeShowing = true
                case .questionPaper:
                    markschemeShowing = false
                case .datasheet:
                    datasheetShowing = false
                case .other:
                    return
            }
        }
    }
}

extension PDFView {
    func calculatedMarkschemeIndex() -> Double {
        (bundle.markScheme != nil && markschemeShowing) ? 1 : 0
    }
    
    func calculatedQuestionPaperIndex() -> Double {
        (bundle.questionPaper != nil && !markschemeShowing) ? 1 : 0
    }
    
    func calculatedDatasheetIndex() -> Double {
        (bundle.questionPaper != nil && datasheetShowing) ? 2 : 0
    }
    
    func canShowMCQAnswerOverlay() -> Bool {
        (bundle.metadata.paperNumber == .paper1) && !(bundle.markScheme.map { $0.metadata.answers }).isNilOrEmpty && (answerOverlayShowing == true)
    }
    
    func showMCQAnswerOverlay() {
        answerOverlayShowing = true
        markschemeShowing = false
    }
}
