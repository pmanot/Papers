//
// Copyright (c) Purav Manot
//


import Foundation
import SwiftUI

extension GeometryProxy {
    var center: CGPoint {
        CGPoint(x: self.size.width/2, y: self.size.height/2)
    }
    
    var bottom: CGPoint {
        CGPoint(x: self.size.width/2, y: self.size.height - 40)
    }
    
    var top: CGPoint {
        CGPoint(x: self.size.width/2, y: 40)
    }
}
