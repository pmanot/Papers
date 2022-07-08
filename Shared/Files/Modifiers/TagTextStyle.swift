//
// Copyright (c) Purav Manot
//

import SwiftUI

struct TagTextStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var color: Color = .accentColor
    func body(content: Content) -> some View {
        switch colorScheme {
            case .dark:
                content
                    .foregroundColor(.primary)
                    .font(.subheadline)
                    .padding(7)
                    .background(color.opacity(0.7).cornerRadius(8))
                    .shadow(radius: 0.5)
            default:
                content
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(7)
                    .background(color.opacity(0.7).cornerRadius(8))
                    .shadow(radius: 0.5)
        }
        
    }
}
