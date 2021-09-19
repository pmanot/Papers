//
//  DataSheet.swift
//  Papers
//
//  Created by Purav Manot on 14/07/21.
//

import SwiftUI

struct DataSheet: View {
    @State var isShowing: Bool = false
    var body: some View {
        ZStack {
            PDFPageView(QuestionPaper.example, pages: [])
                .modifier(RoundedBorder())
                .clipped()
        }
    }
}

struct DataSheet_Previews: PreviewProvider {
    static var previews: some View {
        DataSheet()
    }
}
