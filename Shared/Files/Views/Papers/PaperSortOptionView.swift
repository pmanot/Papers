//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct PaperSortOptionView: View {
    @Binding var sortBy: PapersListSectionType
    @Binding var sortInsideBy: PapersListSectionType
    
    var body: some View {
        Section {
            Menu {
                Picker("", selection: $sortBy) {
                    Text("Year")
                        .tag(PapersListSectionType.byYear)
                    Text("Month")
                        .tag(PapersListSectionType.byMonth)
                    Text("Paper")
                        .tag(PapersListSectionType.byPaperNumber)
                    Text("Subject")
                        .tag(PapersListSectionType.bySubject)
                }
            } label: {
                Text("Section by")
            }
            
            Menu {
                Picker("", selection: $sortInsideBy) {
                    Text("Year")
                        .tag(PapersListSectionType.byYear)
                    Text("Month")
                        .tag(PapersListSectionType.byMonth)
                    Text("Paper")
                        .tag(PapersListSectionType.byPaperNumber)
                    Text("Subject")
                        .tag(PapersListSectionType.bySubject)
                        
                }
            } label: {
                Text("Group by")
            }
        }
    }
}

struct PaperSortOptionView_Previews: PreviewProvider {
    static var previews: some View {
        PaperSortOptionView(sortBy: .constant(.byYear), sortInsideBy: .constant(.byMonth))
    }
}
