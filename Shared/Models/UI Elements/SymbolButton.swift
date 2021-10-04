//
// Copyright (c) Purav Manot
//

import SwiftUI

struct SymbolButton: View {
    @State private var toggled: Bool = false
    
    private var systemName: String
    private var toggledSystemName: String = ""
    var action: () -> Void = {}
    
    init(_ systemName: String, onToggle: String = "", _ action: @escaping () -> Void){
        self.systemName = systemName
        self.toggledSystemName = onToggle
        self.action = action
    }
    
    init(_ systemName: String, _ action: @escaping () -> Void){
        self.systemName = systemName
        self.toggledSystemName = systemName
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            self.action()
            toggled.toggle()
        }){
            Image(systemName: self.toggled ? toggledSystemName : systemName)
        }
    }
}
