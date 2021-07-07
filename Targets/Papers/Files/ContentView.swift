//
//  ContentView.swift
//  Papers
//
//  Created by Purav Manot on 07/07/21.
//

import SwiftUI
import Filesystem

struct ContentView: View {
    @EnvironmentObject var papers: Papers
    var body: some View {
        PapersView(pdf: .constant(PDFFileDocument()))
            .environmentObject(Papers())
            .onAppear {
                let directory = DocumentDirectory()
                if papers.papers == [] {
                    directory.write(try! JSONEncoder().encode([QuestionPaper("9701_m20_qp_42"), QuestionPaper("9702_w20_qp_22"), QuestionPaper.example, QuestionPaper.example2].codableQuestionPaper()), to: "Papers")
                    print("Papers written!")
                } else {
                    print("Papers loaded!")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
