//
//  CorrectionView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 03/01/22.
//

import SwiftUI
import SwiftUIX

struct TimerView: View {
    @Binding var timeTaken: TimeInterval
    var body: some View {
        HStack {
            Group {
                HStack( spacing: 2) {
                    Text("\(timeTaken.timeComponents().0)")
                        .font(.title3, weight: .black)
                    Text("hours")
                        .font(.caption, weight: .light)
                }
                
                
                HStack( spacing: 2) {
                    Text("\(timeTaken.timeComponents().1)")
                        .font(.title3, weight: .black)
                    Text("minutes")
                        .font(.caption, weight: .light)
                }
                
                HStack( spacing: 2) {
                    Text("\(timeTaken.timeComponents().2)")
                        .font(.title3, weight: .black)
                    Text("seconds")
                        .font(.caption, weight: .light)
                }
                
            }
            .padding(5)
            .background(BlurEffectView(style: .systemUltraThinMaterial))
            .border(Color.secondary, cornerRadius: 10)
        }
    }
}

struct CorrectionView: View {
    @Binding var solvedData: PaperSolvedData
    @Binding var dismiss: Bool
    
    var body: some View {
        VStack {
            GradeView(solvedData: $solvedData, dismiss: $dismiss)
            TimerView(timeTaken: $solvedData.timeTaken)
        }
    }
}

struct GradeView: View {
    @Binding var solvedData: PaperSolvedData
    @Binding var dismiss: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Grade yourself:")
                    .font(.largeTitle, weight: .heavy)
                Group {
                    HStack {
                        Text("Correct:")
                            .font(.title3, weight: .bold)
                        
                        Spacer()
                        
                        TextField("", value: $solvedData.correct, formatter: NumberFormatter())
                            .textFieldStyle(.plain)
                            .frame(width: 20)
                            .modifier(TagTextStyle())
                    }
                    
                    HStack {
                        Text("Incorrect:")
                            .font(.title3, weight: .bold)
                        
                        Spacer()
                        
                        TextField("", value: $solvedData.incorrect, formatter: NumberFormatter())
                            .textFieldStyle(.plain)
                            .frame(width: 20)
                            .modifier(TagTextStyle())
                    }
                    
                    HStack {
                        Text("Unanswered:")
                            .font(.title3, weight: .bold)
                        
                        Spacer()
                        
                        TextField("", value: $solvedData.correct, formatter: NumberFormatter())
                            .textFieldStyle(.plain)
                            .frame(width: 20)
                            .modifier(TagTextStyle())
                    }
                }
                .padding(5)
                .frame(width: 240)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    withAnimation {
                        dismiss.toggle()
                    }
                }){
                    HStack {
                        Text("Save")
                            .font(.headline, weight: .bold)
                        Image(systemName: .checkmark)
                            .font(.caption, weight: .bold)
                    }
                    
                }
                .foregroundColor(.label)
                .padding(5)
                .background(Color.background)
                .border(Color.secondary, cornerRadius: 8)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        dismiss.toggle()
                    }
                }){
                    Text("Skip")
                        .font(.headline)
                    Image(systemName: .arrowRight)
                        .font(.caption)
                }
                .foregroundColor(.label)
                .padding(5)
                .background(Color.background)
                .border(Color.secondary, cornerRadius: 8)
            }
            .frame(width: 160)
        }
        .frame(height: 250)
        .padding(30)
        .background(BlurEffectView(style: .systemUltraThinMaterial))
        .border(Color.secondary, cornerRadius: 20)
    }
}

// MARK: - Development Preview -

struct CorrectionView_Previews: PreviewProvider {
    static var previews: some View {
        CorrectionView(
            solvedData: .constant(
                PaperSolvedData(
                    paperFilename: SolvedPaper.makeNewTestExample().paperFilename,
                    correct: 0,
                    incorrect: 0,
                    unattempted: 0,
                    timeTaken: 0)
            ),
            dismiss: .constant(false)
        )
    }
}
