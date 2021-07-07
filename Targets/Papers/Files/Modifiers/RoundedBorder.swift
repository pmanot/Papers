//
// Copyright (c) Purav Manot
//


import Foundation
import SwiftUI

struct RoundedBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(antialiased: true))
    }
}
