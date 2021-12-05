//
//  SolvedPaperScrollView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 04/12/21.
//

import SwiftUI

struct SolvedPaperCollectionView: View {
    var solvedPapers: [SolvedPaper] = [SolvedPaper.example, SolvedPaper.example, SolvedPaper.example, SolvedPaper.example]
    @State var expanded: Bool = false
    var body: some View {
        GeometryReader { screen in
            ScrollView(.vertical) {
                ZStack(alignment: .bottomTrailing) {
                    ForEach(0..<solvedPapers.count){ i in
                        MCQSolvedView(solvedPapers[i])
                            .miniSolvedPaperWidget
                            .zIndex(Double(-i))
                            .frame(height: 400)
                            .rotationEffect(rotationValue(i))
                            .position(positionValue(i, screen))
                            
                    }
                }
                .frame(height: expanded ? 300*CGFloat(solvedPapers.count) : 400)
                .onTapGesture {
                    withAnimation(.spring(dampingFraction: 0.8)) {
                        expanded.toggle()
                    }
                }
            }
        }
    }
    
    private func rotationValue(_ i: Int) -> Angle {
        return expanded ? .degrees(0) : .degrees(-min(i, 3)*4)
    }
    
    private func positionValue(_ i: Int, _ screen: GeometryProxy) -> CGPoint {
        if expanded {
        return CGPoint(x: screen.center.x, y: screen.center.y + CGFloat(i*200) - CGFloat(100*min(solvedPapers.count, 3)/2))
        } else {
            return CGPoint(x: screen.center.x - CGFloat(i*5), y: screen.center.y + CGFloat(i*2))
        }
    }
}

struct SolvedPaperCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        SolvedPaperCollectionView()
    }
}

