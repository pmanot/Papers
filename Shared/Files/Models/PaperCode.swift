//
// Copyright (c) Purav Manot
//

import Foundation

/// For e.g. 9702/32/M/J/16.
public struct PaperCode: Codable, Hashable, RawRepresentable {
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

extension PaperCode: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}
