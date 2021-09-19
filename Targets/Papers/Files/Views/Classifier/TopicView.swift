//
//  TopicView.swift
//  Papers
//
//  Created by Purav Manot on 29/06/21.
//

/*
import SwiftUI

struct TopicView: View {
    @Namespace private var animation
    @Binding private var topic: Topic
    @State var keywordCount = 0
    
    init(_ topic: Binding<Topic> = Binding.constant(Topic.example)){
        self._topic = topic
    }
    var body: some View {
        VStack {
            Text("Add Topic")
                .font(.title)
                .fontWeight(.heavy)
                .padding()
            ForEach(0..<keywordCount, id: \.self) { keyword in
                HStack {
                    TextField("", text: $topic.keywords[keyword])
                        .font(.title2)
                        .foregroundColor(.primary)
                    Image(systemName: "xmark.square.fill")
                        .font(.title)
                        .foregroundColor(.primary)
                }
                .matchedGeometryEffect(id: "keyword", in: animation)
            }
            .frame(width: 300)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondary))
            .modifier(RoundedBorder())
            .onChange(of: topic, perform: { value in
                keywordCount = topic.keywords.count
            })
            ZStack {
                Image(systemName: "plus")
                    .font(.title)
                    .padding(4)
                    .background(Color.secondary.cornerRadius(10))
                    .modifier(RoundedBorder())
                    .matchedGeometryEffect(id: "keyword", in: animation)
                
                Button(action: {topic.keywords.append("new")}){
                    Image(systemName: "plus")
                        .font(.title)
                        .padding(4)
                        .background(Color.secondary.cornerRadius(10))
                        .modifier(RoundedBorder())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        TopicView()
    }
}
*/

// in progress


