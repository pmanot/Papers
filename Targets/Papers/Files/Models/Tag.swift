//
// Copyright (c) Purav Manot
//


import Foundation

struct Tag {
    var name: String
    var keywords: [String]
    
    init(_ name: String){
        self.name = name
        self.keywords = [name]
    }
}
