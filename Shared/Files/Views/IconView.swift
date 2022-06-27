//
//  IconView.swift
//  Papers
//
//  Created by Purav Manot on 27/06/22.
//

import SwiftUI

struct IconView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder()
                .frame(width: 100, height: 100)
            
            ForEach(0..<10){ i in
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.5)
                    .foregroundColor(.secondary)
                    .frame(width: 60, height: 80)
                    .offset(x: -5 + CGFloat(i), y: -5 + CGFloat(i))
            }
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.secondary)
                .frame(width: 60, height: 80)
                .offset(x: 5, y: 5)
        }
        
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}
