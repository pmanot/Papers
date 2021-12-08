//
// Copyright (c) Purav Manot
//

import SwiftUI

struct SolvedPaperCollectionView: View {
    var solvedPapers: [SolvedPaper]
    @Binding var expanded: Bool
    @Namespace private var paperCards
    
    init(solvedPapers: [SolvedPaper], expanded: Binding<Bool> = .constant(false)){
        self.solvedPapers = solvedPapers
        self._expanded = expanded
    }
    
    var body: some View {
        ZStack {
            switch expanded {
                case true:
                    VStack {
                        
                        ForEach(0..<solvedPapers.count, id: \.self){ i in
                            MCQSolvedView(solvedPapers[i])
                                .miniSolvedPaperWidget
                                .frame(width: 400)
                                .matchedGeometryEffect(id: i, in: paperCards)
                                .zIndex(Double(solvedPapers.count - i))
                                .padding(5)
                        }
                    }
                    .zIndex(10)
                case false:
                    ForEach(0..<solvedPapers.count, id: \.self){ i in
                        MCQSolvedView(solvedPapers[i])
                            .miniSolvedPaperWidget
                            .frame(width: 400)
                            .rotationEffect(rotationValue(i))
                            .matchedGeometryEffect(id: i, in: paperCards)
                            .zIndex(Double(solvedPapers.count - i))
                    }
            }
        }
        .onTapGesture {
            expand()
        }
    }
}

extension SolvedPaperCollectionView {
    private func rotationValue(_ i: Int) -> Angle {
        expanded ? .degrees(0) : .degrees(-min(i, 3)*4)
    }
    
    private func calculatedOffset(_ i: Int, screen: GeometryProxy) -> CGFloat {
        expanded ? CGFloat(100) : screen.center.y - CGFloat(i)*CGFloat(solvedPapers.count - 1)*25
    }
    
    private func expand() {
        withAnimation(.spring(dampingFraction: 0.8)) {
            expanded.toggle()
        }
    }
    
    private func calculatedHeight() -> CGFloat {
        expanded ? CGFloat(200*solvedPapers.count) : CGFloat(300)
    }
}

struct SolvedPaperCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        SolvedPaperCollectionView(solvedPapers: [SolvedPaper.example, SolvedPaper.example, SolvedPaper.example, SolvedPaper.example])
    }
}

