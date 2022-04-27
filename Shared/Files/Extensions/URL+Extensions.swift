//
// Copyright (c) Purav Manot
//

import Foundation

extension URL {
    func getPaperCode() -> String {
        self.deletingPathExtension().lastPathComponent
    }
}
