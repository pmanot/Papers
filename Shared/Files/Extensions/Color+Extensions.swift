//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

extension Color {
    init(_ r: Double, _ g: Double, _ b: Double) {
        self.init(red: Double(r/255), green: Double(g/255), blue: Double(b/255))
    }
    
    static let primaryInverted = Color("primaryInverted", bundle: Bundle.main)
    static let background = Color("background", bundle: Bundle.main)
    static let dark = Color(18, 18, 18)
}
