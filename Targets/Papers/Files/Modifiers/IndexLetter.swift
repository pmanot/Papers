//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

struct IndexLetter: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .font(.body, weight: .bold)
            .frame(width: 30, height: 30)
            .colorInvert()
            .background(Color.primary.clipShape(RoundedRectangle(cornerRadius: 10)))
            .modifier(RoundedBorder())
    }
}
