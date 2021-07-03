//
//  RoundedBorder.swift
//  Papers
//
//  Created by Purav Manot on 02/07/21.
//

import Foundation
import SwiftUI

struct RoundedBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(antialiased: true))
    }
}
