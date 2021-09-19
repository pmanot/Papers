//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

extension Color {
    init(_ r: Int, g: Int, b: Int) {
        self.init(UIColor(CGFloat(r/255), CGFloat(g/255), CGFloat(b/255)))
    }
}
