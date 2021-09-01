//
//  SearchBar.swift
//  Papers
//
//  Created by Purav Manot on 06/08/21.
//

import SwiftUI

struct SearchBar: View {
    @State var searchText = ""
    @State var showCancelButton: Bool = false
    @State var questionList: [Question] = []
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.subheadline)
                    TextField("Search", text: $searchText, onEditingChanged: { _ in
                        self.showCancelButton = true
                        
                    }, onCommit: {})
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            self.searchText = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.secondary, lineWidth: 0.1, antialiased: true))
                .cornerRadius(10.0)
                
                if showCancelButton {
                    Button("Cancel"){
                        endEditing()
                        withAnimation(.easeOut) {
                            self.searchText = ""
                            self.showCancelButton = false
                        }
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding()
            
            List {
                ForEach(questionList.filter { $0.pages.map {$0.rawText}.reduce("", +).lowercased().contains(searchText.lowercased()) }, id: \.id) { question in
                    VStack {
                        Text("\(question.index.number)")
                            .font(.headline)
                        Text(question.pages.first!.metadata.paperCode.id)
                            .font(.caption)
                    }
                }
            }

        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
