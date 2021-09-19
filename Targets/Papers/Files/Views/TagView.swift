//
// Copyright (c) Purav Manot
//

import SwiftUI

struct TagView: View {
    @Binding var tags: [Tag]
    @Binding var selected: Tag?
    
    init(tags: Binding<[Tag]>, selection: Binding<Tag?>){
        self._tags = tags
        self._selected = selection
    }
    
    var body: some View {
        ScrollView(.horizontal){
            HStack(alignment: .top){
                ForEach(tags, id: \.self){ tag in
                    Button(action: {
                            selected = tag
                    }){
                        Text(tag.search != "" ? tag.search : tag.type.rawValue)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .opacity(0.6)
                            .padding(6)
                            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(tag.color))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 0.4))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
            .padding()
        }
    }
}


