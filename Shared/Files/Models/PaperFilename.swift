//
// Copyright (c) Purav Manot
//

import Foundation

/// e.g. `9702_s16_qp_32` or `9702_s16_ms_32`
///
/// This is *not* the full URL to the paper, it is _only_ the file name.
public struct PaperFilename: Codable, Hashable, RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(from decoder: Decoder) throws {
        try self.init(rawValue: String(from: decoder))
    }
    
    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}

extension PaperFilename {
    public var type: CambridgePaperType {
        if rawValue.split(separator: "_")[2] == "ms" {
            return .markScheme
        } else if rawValue.split(separator: "_")[2] == "qp" {
            return .questionPaper
        } else {
            return .other
        }
    }
}

// MARK: - Conformances -

extension PaperFilename: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

// MARK: - Helpers -

extension URL {
    func getPaperFilenameString() -> String {
        getPaperFilename().rawValue
    }
    
    func getPaperFilename() -> PaperFilename {
        .init(rawValue: self.deletingPathExtension().lastPathComponent)
    }
}
