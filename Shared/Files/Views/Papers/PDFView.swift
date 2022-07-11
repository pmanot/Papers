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
            compiledPDF.insert(page, at: compiledPDF.pageCount)
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
    @State var paperSelection: CambridgePaperType = .questionPaper
    @State var testMode = false
    var onSave: () -> () {
        {
            if applicationStore.papersDatabase.paperBundles.contains(bundle) {
                !applicationStore.papersDatabase.savedPaperIndices.contains(bundle.index(in: applicationStore.papersDatabase.paperBundles)) ? applicationStore.papersDatabase.savePaper(bundle: bundle) : applicationStore.papersDatabase.removePaper(bundle: bundle)
            }
        }
    }
    
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
                    
                    if !bundle.markScheme.isNil {
                        // Marking scheme
                        WrappedPDFView(pdf: bundle.markScheme!.pdf)
                            .zIndex(calculatedMarkschemeIndex())
                    }
                    
                    if !bundle.datasheetBySubject.isNil {
                        // Data sheet
                        WrappedPDFView(pdf: bundle.datasheetBySubject!)
                            .zIndex(calculatedDatasheetIndex())
                    }
                    
                }
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                
                Toolbar(markschemeShowing: $markschemeShowing, answerOverlayShowing: $answerOverlayShowing, paperSelection: $paperSelection, testMode: $testMode, datasheetShowing: $datasheetShowing, save: onSave, isSaved: false)
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
                default:
                    return
            }
        }
    }
}

extension PDFView {
    func calculatedMarkschemeIndex() -> Double {
        (paperSelection == .markScheme) ? 1 : 0
    }
    
    func calculatedQuestionPaperIndex() -> Double {
        (paperSelection == .questionPaper) ? 1 : 0
    }
    
    func calculatedDatasheetIndex() -> Double {
        (paperSelection == .datasheet) ? 2 : 0
    }
    
    func canShowMCQAnswerOverlay() -> Bool {
        (bundle.metadata.paperNumber == .paper1) && (bundle.markScheme.map { $0.metadata.multipleChoiceAnswers })?.keys.count ?? 0 == 40 && (answerOverlayShowing == true)
    }
    
    func showMCQAnswerOverlay() {
        answerOverlayShowing = true
        markschemeShowing = false
    }
}
