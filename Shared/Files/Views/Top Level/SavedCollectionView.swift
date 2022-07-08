//
//  SavedCollectionView.swift
//  Papers
//
//  Created by Purav Manot on 05/07/22.
//

import SwiftUI

struct SavedCollectionView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    let savedBundles: [CambridgePaperBundle] = []
    let savedQuestions: [Question] = []
    @State private var selectedType: CambridgeSavedItemType = .bundle
    
    var body: some View {
        List {
            Section {
                Picker("", selection: $selectedType){
                    Text("Paper")
                        .tag(CambridgeSavedItemType.bundle)
                    Text("Question")
                        .tag(CambridgeSavedItemType.question)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            switch selectedType {
                case .bundle:
                    ForEach(applicationStore.papersDatabase.paperBundles, id: \.metadata.code) { bundle in
                        Row(paperBundle: bundle, searchText: nil)
                    }
                case .question:
                    ForEach(savedQuestions) { question in
                        Text(question.rawText)
                    }
            }
            
            
            
        }
        
        
    }
    
    private enum CambridgeSavedItemType: String, Hashable {
        case bundle = "Paper"
        case question = "Question"
    }
}


struct SavedCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        SavedCollectionView()
            .environmentObject(ApplicationStore())
    }
}
