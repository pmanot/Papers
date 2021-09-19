//
//  DefinitionsView.swift
//  Papers
//
//  Created by Purav Manot on 11/07/21.
//

import SwiftUI

struct DefinitionsView: View {
    @State var definitions: [Definition] = []
    var body: some View {
        List(definitions, id: \.id){ _ in 
            Text("Defintion")
        }
    }
}

struct DefinitionsView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionsView()
    }
}
