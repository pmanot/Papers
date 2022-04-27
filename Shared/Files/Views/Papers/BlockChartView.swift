//
//  BlockChart.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 02/01/22.
//

import SwiftUI

struct BlockChartView: View {
    var color: Color
    let value: CGFloat
    let maxValue: CGFloat
    
    init(_ color: Color, value: Int, maxValue: Int){
        self.color = color
        self.value = CGFloat(value)
        self.maxValue = CGFloat(maxValue)
    }
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<Int(maxValue), id: \.self){ i in
                Rectangle()
                    .foregroundColor(colorByIndex(i))
            }
        }
        .drawingGroup()
    }
    
    
    private func colorByIndex(_ i: Int) -> Color {
        Int(self.value) >= i + 1 ? color : Color.primary.opacity(0.3)
    }
}

struct BlockChartView_Previews: PreviewProvider {
    static var previews: some View {
        BlockChartView(.pink, value: 10, maxValue: 40)
            .frame(width: 250, height: 30)
    }
}
