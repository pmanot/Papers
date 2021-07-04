//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

struct IndexNumber: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .font(.largeTitle, weight: .heavy)
            .frame(width: 38, height: 38)
            .modifier(RoundedBorder())
            .padding(3)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(lineWidth: 2, antialiased: true)
            )
    }
}
