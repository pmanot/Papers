//
// Copyright (c) Purav Manot
//

import SwiftUIX

struct PapersView: View {
    var papers: [Paper] = []
    
    @State var paperTapped: Bool = false
    
    init(_ papers: [Paper] = []) {
        self.papers = papers
    }
    
    var body: some View {
        NavigationView {
            List(papers) { paper in
                Row(paper: paper)
                    .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("Papers")
        }
    }
}

extension PapersView {
    struct Row: View {
        let paper: Paper
        
        var body: some View {
            NavigationLink(destination: QuestionList(paper)) {
                HStack {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder()
                            .frame(height: 50)
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(paper.subject.rawValue)
                                        .font(.body)
                                        .fontWeight(.heavy)
                                    Text(String(paper.year))
                                        .font(.callout)
                                        .fontWeight(.regular)
                                }
                                Text(paper.paperCode)
                                    .font(.caption)
                                    .fontWeight(.light)
                            }
                            .padding(.leading, 10)
                            
                            Image(systemName: "chevron.right.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.leading, 120)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
    }
}

struct PapersView_Previews: PreviewProvider {
    static var previews: some View {
        PapersView([Paper.example])
    }
}
