//
//  SearchView.swift
//  Papers
//
//  Created by Purav Manot on 01/09/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var papers: PapersDatabase
    @State var searchResults = SearchResults([])
    @State var searchOptions = ["Question Papers", "Questions"]
    @State var searchSelection = "Question Papers"
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Group {
                    switch searchSelection {
                    case searchOptions[1]:
                        List(searchResults.filteredQuestionList, id: \.id){ question in
                            QuestionList.Row(question)
                        }
                    default:
                        List(searchResults.filteredPapers, id: \.self){ paper in
                            PapersView.ListView.Row(paper: paper)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                Picker("", selection: $searchSelection) {
                    ForEach(searchOptions, id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300)
                .padding(20)
            }
            .navigationBarItems(leading: EmptyView(), center: (SearchBar(filteredContents: $searchResults)).width(360))
        }
        .onAppear {
            searchResults = SearchResults(papers.cambridgePapers)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(PapersDatabase())
    }
}
