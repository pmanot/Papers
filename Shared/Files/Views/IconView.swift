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
                .foregroundColor(.systemBackground.opacity(0.8))
                .frame(width: 100, height: 100)
                .shadow(radius: 1)
            Group {
                RoundedRectangle(cornerRadius: 10)
                    .offset(.uniform(4))
                RoundedRectangle(cornerRadius: 10)
                    .offset(.uniform(0))
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 10)
                    .offset(.uniform(-4))
            }
            .foregroundColor(.pink)
            .shadow(radius: 2)
            .frame(width: 60, height: 80)
            Image(systemName: .booksVerticalCircleFill)
                .font(.system(size: 50))
                .foregroundColor(.white)
                .offset(.uniform(-4))
        }
        
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}

extension CGPoint {
    static func uniform(_ r: Double) -> CGPoint {
        CGPoint.init(x: r, y: r)
    }
}
