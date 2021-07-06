//
// Copyright (c) Purav Manot
//

import SwiftUI
import Filesystem

@main
struct PapersApp: App {
    let papers = [QuestionPaper("9701_m20_qp_42"), QuestionPaper("9702_w20_qp_22"), QuestionPaper.example, QuestionPaper.example2]
    var body: some Scene {
        WindowGroup {
            PapersView(papers, pdf: .constant(PDFFileDocument()))
                .environmentObject(Answers())
        }
    }
}
