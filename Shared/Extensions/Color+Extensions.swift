//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

extension Color {
    init(_ r: Int, g: Int, b: Int) {
        self.init(UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: 0.5))
    }
    
    static let primaryInverted = Color("primaryInverted", bundle: Bundle.main)
}
