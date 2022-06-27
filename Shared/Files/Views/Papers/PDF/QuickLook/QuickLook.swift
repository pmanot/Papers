//
//  QuickLook.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 09/12/21.
//

import SwiftUI
import PDFKit

struct QuickLook: View {
    @State private var showingPreview = true
    var url: URL = QuickLook.example

    var body: some View {
        ZStack {
            PreviewController(url: url, isPresented: $showingPreview)
        }
    }
}

struct QuickLook_Previews: PreviewProvider {
    static var previews: some View {
        QuickLook()
    }
}


extension QuickLook {
    static var example = URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_qp_42", ofType: "pdf")!)
}
