//
// Copyright (c) Purav Manot
//

import SwiftUI
import PDFKit

struct Home: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    
    var body: some View {
        VStack {
            Text("Welcome, User")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(applicationStore.papersDatabase.paperBundles.compactMap { $0.questionPaper }.questions().shuffled(), id: \.hashValue){ question in
                        NavigationLink(destination: QuestionView(question)) {
                            VStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.white)
                                    .opacity(0.2)
                                    .overlay(
                                        Text(question.rawText)
                                            .padding()
                                    )
                                    .border(Color.primary, width: 0.5, cornerRadius: 20)
                                
                                HStack {
                                    Text(question.metadata.questionPaperCode)
                                        .fontWeight(.regular)
                                        .padding(8)
                                        .border(Color.primary, width: 0.5, cornerRadius: 10, style: .circular)
                                    Text(String(question.index.number))
                                        .fontWeight(.regular)
                                        .frame(width: 20)
                                        .padding(7)
                                        .border(Color.primary, width: 0.5, cornerRadius: 10, style: .circular)
                                }
                                .padding(5)
                                .opacity(0.6)
                            }
                            .frame(width: 300, height: 300)
                            .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    /* Preview
                    ForEach(0..<10) { _ in
                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.white)
                                .opacity(0.2)
                                .overlay(
                                    Text(PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9702_s18_qp_42", ofType: "pdf")!))!.page(at: 4)!.string!)
                                        .fontWeight(.light)
                                        .padding()
                                )
                                .border(.black, width: 0.5, cornerRadius: 20)
                            
                            Text("9702/42/O/N/19")
                                .fontWeight(.regular)
                                .padding(8)
                                .border(.black, width: 0.5, cornerRadius: 10, style: .circular)
                                .opacity(0.6)
                        }
                        .frame(width: 300, height: 300)
                        .padding()
                    }*/
                    
                }
            }
            .frame(height: 400)
            
        }
        .navigationTitle("Home")
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Home()
                .environmentObject(ApplicationStore())
        }
    }
}
