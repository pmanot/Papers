//
// Copyright (c) Purav Manot
//

import SwiftUI
import Filesystem

@main

struct PapersApp: App {
    var directory = DocumentDirectory()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Papers())
        }
    }
}

class Papers: ObservableObject {
    var papers: [QuestionPaper] {
        let directory = DocumentDirectory()
        let data = directory.read(from: "Papers") ?? []
        return try! JSONDecoder().decode([CodableQuestionPaper].self, from: data).questionPaper()
    }
}
