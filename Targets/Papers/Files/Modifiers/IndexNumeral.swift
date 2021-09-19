//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

struct IndexNumeral: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .font(.body, weight: .bold)
            .frame(width: 23, height: 23)
            .colorInvert()
            .background(Color.primary.clipShape(RoundedRectangle(cornerRadius: 8)))
            .padding(2)
            .modifier(RoundedBorder())
    }
}
