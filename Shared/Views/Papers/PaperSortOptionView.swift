//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct PaperSortOptionView: View {
    @Binding var sortBy: SortType
    @Binding var sortInsideBy: SortType
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sort")
                .font(.largeTitle, weight: .heavy)
                .foregroundColor(.label)
                .padding(.bottom)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Section by:")
                    .font(.subheadline, weight: .light)
                    .padding(.leading, 5)
                Picker("", selection: $sortBy) {
                    Text("Year")
                        .tag(SortType.sortByYear)
                    Text("Month")
                        .tag(SortType.sortByMonth)
                    Text("Paper")
                        .tag(SortType.sortByPaperNumber)
                    Text("Subject")
                        .tag(SortType.sortBySubject)
                }
                .pickerStyle(.segmented)
                
                Spacer()
            
                Text("Group by:")
                    .font(.subheadline, weight: .light)
                    .padding(.leading, 5)
                Picker("", selection: $sortInsideBy) {
                    Text("Year")
                        .tag(SortType.sortByYear)
                    Text("Month")
                        .tag(SortType.sortByMonth)
                    Text("Paper")
                        .tag(SortType.sortByPaperNumber)
                    Text("Subject")
                        .tag(SortType.sortBySubject)
                        
                }
                .pickerStyle(.segmented)
            }
            .frame(height: 150)
            
            
            
        }
        .padding()
    }
}

struct PaperSortOptionView_Previews: PreviewProvider {
    static var previews: some View {
        PaperSortOptionView(sortBy: .constant(.sortByYear), sortInsideBy: .constant(.sortByMonth))
    }
}
