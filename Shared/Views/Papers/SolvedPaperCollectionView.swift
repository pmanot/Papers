//
// Copyright (c) Purav Manot
//

import SwiftUIX

struct SolvedPaperCollectionView: View {
    var solvedPapers: [SolvedPaper]

    @Binding var expanded: Bool

    @Namespace private var paperCards

    struct ItemView: View {
        let index: Int
        let paper: SolvedPaper
        let isExpanded: Bool

        @State var hasAppeared: Bool = false

        var body: some View {
            MCQSolvedView(paper)
                .miniSolvedPaperWidget
                .frame(width: Screen.main.width * 0.95)
                .rotationEffect(
                    hasAppeared
                        ? rotation(forIndex: index, expanded: isExpanded)
                        : rotation(forIndex: index, expanded: !isExpanded)
                )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        withAnimation {
                            hasAppeared = true
                        }
                    }
                }
        }

        private func rotation(forIndex i: Int, expanded: Bool) -> Angle {
            if expanded {
                return .degrees(0)
            } else {
                return .degrees(-min(i, 3) * 4)
            }
        }
    }

    var body: some View {
        ZStack {
            switch expanded {
                case true:
                    VStack {
                        ForEach(enumerating: solvedPapers) { (index, paper) in
                            ItemView(
                                index: index,
                                paper: paper,
                                isExpanded: expanded
                            )
                            .matchedGeometryEffect(id: paper.id, in: paperCards)
                            .zIndex(Double(solvedPapers.count - index))
                        }
                    }
                    .zIndex(10)
                case false:
                    ForEach(enumerating: solvedPapers) { (index, paper) in
                        ItemView(
                            index: index,
                            paper: paper,
                            isExpanded: expanded
                        )
                        .matchedGeometryEffect(id: paper.id, in: paperCards)
                        .zIndex(Double(solvedPapers.count - index))
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
    
    private func expand() {
        withAnimation(.spring(dampingFraction: 0.8)) {
            expanded.toggle()
        }
    }
}

struct SolvedPaperCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .preferredColorScheme(.dark)
    }

    struct Preview: View {
        @State private var examples = [SolvedPaper.makeNewExample(), SolvedPaper.makeNewExample(), SolvedPaper.makeNewExample(), SolvedPaper.makeNewExample()
        ]

        @State private var isExpanded: Bool = false

        var body: some View {
            ScrollView {
                VStack {
                    Toggle("Expand", isOn: $isExpanded.animation(.default))

                    SolvedPaperCollectionView(solvedPapers: examples, expanded: $isExpanded)
                }
            }
        }
    }
}
