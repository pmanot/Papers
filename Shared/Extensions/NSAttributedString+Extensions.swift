//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

extension NSAttributedString {
    func fetchBoldStrings() -> [String] {
        var boldStrings: [String] = []
        self.enumerateAttributes(in: NSRange(location: 0, length: self.length), options: []) { (attrs, range, _) in
            if let font = attrs[NSAttributedString.Key.font] as? UIFont {
                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    boldStrings.append(self.attributedSubstring(from: range).string)
                }
            }
        }
        return boldStrings
    }
}
