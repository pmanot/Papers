//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

struct SolvedPaperCard: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    let solvedPaper: SolvedPaper
    var bundle: CambridgePaperBundle! {
        applicationStore.papersDatabase.paperBundles.first { $0.metadata.code == solvedPaper.paperCode }
    }
    @State var goToContents: Bool = false
    init(_ solvedPaper: SolvedPaper) {
        self.solvedPaper = solvedPaper
    }
    var body: some View {
        HStack(alignment: .top) {
            blockChartWidget
            
            VStack {
                HStack(spacing: 0){
                    Text("\(solvedPaper.correctAnswers.count)")
                        .font(.title2, weight: .black)
                    Text("/")
                        .font(.title, weight: .light)
                    Text("\(solvedPaper.allAnswers.count)")
                        .font(.largeTitle, weight: .black)
                }
                .padding(3)
                .border(Color.secondary, width: 0.5, cornerRadius: 8, antialiased: true)
                .padding([.leading, .vertical], 5)
                .padding(4)
                
                Text(solvedPaper.solvedOn.relativeDescription)
                    .padding()
                NavigationLink(destination: PaperContentsView(bundle: bundle), isActive: $goToContents) {
                    Image(systemName: .arrowRightCircleFill)
                        .font(.title)
                        .foregroundColor(Color.blue)
                        .opacity(0.5)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .border(Color.secondary, width: 1, cornerRadius: 10, antialiased: true)
        .background(VisualEffectBlurView(blurStyle: .systemThinMaterial).cornerRadius(10))
        .contextMenu {
            Button(action: {
                if bundle != nil {
                    withAnimation {
                        goToContents.toggle()
                    }
                }
            }){
                Label("Go to paper", systemImage: .arrowRightCircle)
            }
            Button(role: .destructive, action: {
                withAnimation {
                    delete(database: applicationStore.papersDatabase)
                }
            }){
                Label("Delete solved paper", systemImage: .binXmark)
            }
        }
        
    }
}

/*
struct SolvedPaperCard_Previews: PreviewProvider {
    static var previews: some View {
        SolvedPaperCard()
    }
}
*/

extension SolvedPaperCard {
    func delete(database: PapersDatabase) {
        database.solvedPapers.removeValue(forKey: solvedPaper.paperCode)
    }
    private var barChartWidget: some View {
        VStack(spacing: 1) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Correct answers:")
                        .font(.caption, weight: .light)
                    Text("\(solvedPaper.correctAnswers.count)")
                        .font(.subheadline, weight: .bold)
                }
                .padding(.leading, 6)
                    
                BarView(Color.green, value: solvedPaper.correctAnswers.count, maxValue: solvedPaper.allAnswers.count)
                    .frame(width: 150, height: 25)
            }
            .padding(3)
                
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Incorrect answers:")
                        .font(.caption, weight: .light)
                    Text("\(solvedPaper.incorrectAnswers.count)")
                        .font(.subheadline, weight: .bold)
                }
                .padding(.leading, 6)
                
                BarView(Color.red, value: solvedPaper.incorrectAnswers.count, maxValue: solvedPaper.allAnswers.count)
                    .frame(width: 150, height: 25)
            }
            .padding(3)
                
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Unsolved answers:")
                        .font(.caption, weight: .light)
                    Text("\(solvedPaper.unsolvedAnswers.count)")
                        .font(.subheadline, weight: .bold)
                }
                .padding(.leading, 6)
                
                BarView(Color.yellow, value: solvedPaper.unsolvedAnswers.count, maxValue: solvedPaper.allAnswers.count)
                    .frame(width: 150, height: 25)
            }
            .padding(3)
        }
    }
    
    private var blockChartWidget: some View {
        VStack(spacing: 1) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Correct answers:")
                        .font(.caption, weight: .light)
                    Text("\(solvedPaper.correctAnswers.count)")
                        .font(.subheadline, weight: .bold)
                }
                .padding(.leading, 1)
                .padding(.bottom, 1)
                    
                BlockChartView(Color.green, value: solvedPaper.correctAnswers.count/2, maxValue: solvedPaper.allAnswers.count/2)
                    .frame(width: 150, height: 20)
            }
            .padding(8)
                
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Incorrect answers:")
                        .font(.caption, weight: .light)
                    Text("\(solvedPaper.incorrectAnswers.count)")
                        .font(.subheadline, weight: .bold)
                }
                .padding(.leading, 1)
                
                BlockChartView(Color.red, value: solvedPaper.incorrectAnswers.count/2, maxValue: solvedPaper.allAnswers.count/2)
                    .frame(width: 150, height: 20)
            }
            .padding(8)
                
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Unsolved answers:")
                        .font(.caption, weight: .light)
                    Text("\(solvedPaper.unsolvedAnswers.count)")
                        .font(.subheadline, weight: .bold)
                }
                .padding(.leading, 1)
                .padding(.bottom, 1)
                
                BlockChartView(Color.yellow, value: solvedPaper.unsolvedAnswers.count/2, maxValue: solvedPaper.allAnswers.count/2)
                    .frame(width: 150, height: 20)
            }
            .padding(8)
        }
    }
    
}
