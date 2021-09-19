//
// Copyright (c) Purav Manot
//

import SwiftUI

struct SearchBar: View {
    @State var searchText = ""
    @State var showCancelButton: Bool = false
    @State var questionList: [Question] = []
    @Binding var filteredContents: SearchResults
    @State var tagPositions: [TagType : CGFloat] = [:]
    @State private var tags = [Tag("", type: .papercode), Tag("", type: .question), Tag("", type: .answer)]
    @State private var selectedTag: Tag? = nil
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.subheadline)
                    ZStack(alignment: .leading) {
                        TextField("Search", text: $searchText, onEditingChanged: { _ in
                            self.showCancelButton = true
                        }, onCommit: {})
                        .foregroundColor(.primary)
                        .onChange(of: searchText, perform: { text in
                            filteredContents.update(searchText)
                            if text.contains("q#") {
                                let questionText = text.split(separator: "q").last?.split(separator: "#").last?.split(separator: " ").first ?? ""
                                tags[1] = Tag(String(questionText), type: .question)
                                tagPositions[TagType.question] = CGFloat(text.split(separator: "#")[0].count - 1)
                            } else {
                                tags[1] = Tag("", type: .question)
                                tagPositions = [:]
                            }
                        })
                        
                        ForEach(Array(tagPositions.keys), id: \.self) { tagType in
                            HStack {
                                Text( tags.first { $0.type == tagType }!.search)
                                
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        let _ = tagPositions.removeValue(forKey: tagType)
                                        searchText.remove(substrings: ["q#"])
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                                }
                            }
                            .foregroundColor(.black)
                            .opacity(0.6)
                            .padding(6)
                            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(tags.first { $0.type == tagType }!.color))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 0.4))
                            .offset(tagPositions[tagType]!)
                            .id(UUID())
                                
                        }
                        
                    }
                    
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
            
        }
        .padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(filteredContents: Binding.constant(SearchResults([])))
    }
}


