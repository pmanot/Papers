//
// Copyright (c) Purav Manot
//

import SwiftUI
import Filesystem
import PDFKit

struct ContentView: View {
    @EnvironmentObject var papers: Papers
    var body: some View {
        PapersView()
            .environmentObject(Papers())
            .onAppear {
                load(papers: papers)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Papers())
    }
}


func load(papers: Papers) {
    let directory = DocumentDirectory()
    let urls = Bundle.main.urls(forResourcesWithExtension: "pdf", subdirectory: .none)!
    if false {
        for url in urls {
            directory.writePDF(pdf: PDFDocument(url: url)!, to: Paper(url: url).filename)
            print("written")
        }
    }
    papers.load()
    if papers.cambridgePapers == [] {
        try! directory.write(Papers.examples, toDocumentNamed: "metadata")
        print("Papers written!")
    } else {
        let urls = directory.findPapers().map { Paper(url: $0) }
        for url in urls {
            papers.cambridgePapers.append(QuestionPaper(url.url))
        }
        print("Papers loaded!")
    }
}
