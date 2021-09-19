//
// Copyright (c) Purav Manot
//

import SwiftUI

struct DefinitionListView: View {
    @State var definitions: [Definition] = []
    var body: some View {
        List(definitions, id: \.id){ _ in 
            Text("Defintion")
        }
    }
}

struct DefinitionListView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionListView()
    }
}
