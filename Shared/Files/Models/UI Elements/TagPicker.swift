//
//  TagPicker.swift
//  Papers
//
//  Created by Purav Manot on 07/07/22.
//

import SwiftUI

struct TagPicker<Item, ID: Hashable, ItemView: View>: View {
    @Namespace var namespace
    let data: AnyRandomAccessCollection<Item>
    let id: KeyPath<Item, ID>
    @Binding var selection: Item
    let content: (Item) -> ItemView
    
    init<C: RandomAccessCollection>(_ collection: C, id: KeyPath<Item, ID>, selection: Binding<Item>, @ViewBuilder content: @escaping (Item) -> ItemView) where C.Element == Item {
        self.data = AnyRandomAccessCollection.init(collection)
        self.id = id
        self._selection = selection
        self.content = content
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack {
                ForEach(data, id: id){ item in
                    ItemContainer(
                        namespace: namespace,
                        content: content(item),
                        isSelected:
                            Binding(get: {
                                item[keyPath: id] == selection[keyPath: id]
                            }, set: { value in
                                if value == true {
                                    selection = item
                                }
                            })
                    )
                }
            }
            .scenePadding()
        }
    }
    
    struct ItemContainer: View {
        let namespace: Namespace.ID
        let content: ItemView
        @Binding var isSelected: Bool
        
        var body: some View {
            content
                .font(.subheadline)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.small)
                .background {
                    if isSelected {
                        Color.pink
                            .cornerRadius(20)
                            .matchedGeometryEffect(id: "selected", in: namespace)
                    } else {
                        Color.clear
                    }
                }
                .animation(.spring().speed(2), value: isSelected)
                .onTapGesture {
                    self.isSelected = true
                }
        }
    }
}

struct TagPicker_Previews: PreviewProvider {
    struct Preview: View {
        @State var selected: String = "foo"
        
        var body: some View {
            TagPicker(["test", "foo", "bar"], id: \.hashValue, selection: $selected){ item in
                Text(item)
            }
        }
    }
    static var previews: some View {
        Preview()
    }
}
