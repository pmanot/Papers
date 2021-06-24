//
//  PapersView.swift
//  Papers
//
//  Created by Purav Manot on 23/06/21.
//

import SwiftUI

struct PapersView: View {
    var paperList: [Paper] = [Paper(paperCode: "9702_s19_qp_21")]
    var body: some View {
        ZStack {
            NavigationView {
                List(paperList) { paper in
                    NavigationLink(destination: PdfView(paper.pdf!, pages: .all)){
                        Text(paper.paperCode)
                    }
                }
            }
        }
    }
}

struct PapersView_Previews: PreviewProvider {
    static var previews: some View {
        PapersView()
    }
}
