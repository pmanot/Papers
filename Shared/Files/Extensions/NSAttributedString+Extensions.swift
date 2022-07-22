//
// Copyright (c) Purav Manot
//

import Foundation
import UIKit

extension NSAttributedString {
    func fetchSubstrings(
        withSymbolicTrait trait: UIFontDescriptor.SymbolicTraits
    ) -> [(range: NSRange, substring: String)] {
        var result: [(range: NSRange, substring: String)] = []

        enumerateAttributes(
            in: NSRange(location: 0, length: self.length),
            options: []
        ) { (attributes, range, _) in
            guard let font = attributes[NSAttributedString.Key.font] as? UIFont else {
                return
            }

            if font.fontDescriptor.symbolicTraits.contains(trait) {
                result.append((range, attributedSubstring(from: range).string))
            }
        }

        return result
    }
}
