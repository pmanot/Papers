//
// Copyright (c) Purav Manot
//

import Foundation

extension TimeInterval {
    func timeComponents() -> (Int, Int, Int) {
        let (hr,  minf) = modf(self / 3600)
        let (min, secf) = modf(60 * minf)
        return (Int(hr), Int(min), Int(60 * secf))
    }
}
