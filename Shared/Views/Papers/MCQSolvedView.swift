//
//  MCQSolvedView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 27/11/21.
//

import SwiftUI

struct MCQSolvedView: View {
    @Binding var solvedPaper: SolvedPaper!
    
    var calculatedPercentage: Double {
        Double(solvedPaper.correctAnswers.count)/Double(solvedPaper.allAnswers.count)*100
    }

    var correctPercentage: Double {
        Double(solvedPaper.correctAnswers.count)/Double(solvedPaper.correctAnswers.count + solvedPaper.incorrectAnswers.count)*100
    }
    
    private var calculatedGrade: String {
        if calculatedPercentage >= 89 {
            return "A"
        } else if calculatedPercentage >= 70 {
            return "B"
        } else if calculatedPercentage >= 60 {
            return "C"
        } else {
            return "D"
        }
    }
    
    init(_ solved: Binding<SolvedPaper?>){
        self._solvedPaper = solved
    }
    
    var body: some View {
        ZStack {
            Color.primaryInverted
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                VStack(spacing: 0) {
                    totalMarksWidget
                        .frame(height: 70)
                        .padding(.horizontal)
                    
                    Line()
                        .stroke(lineWidth: 0.3)
                        .frame(height: 4)
            
                    HStack(alignment: .firstTextBaseline) {
                        percentageWidget
                        Spacer()
                        gradeWidget
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                .border(Color.black, width: 0.3, cornerRadius: 10)
                .padding()
                
                ZStack {
                    pieChartWidget
                        .aspectRatio(1, contentMode: .fit)
                    pieChartLegend
                }
                .padding()
                
                SymbolButton("checkmark.circle.fill"){
                    save(solvedPaper)
                }
                .font(.system(size: 45), weight: .light)
            }
            .padding()
            .edgesIgnoringSafeArea(.all)
            .foregroundColor(.primary)
        }
    }
    
    private var totalMarksWidget: some View {
        HStack {
            Text("Final Score:")
                .font(.title, weight: .light)
            Spacer()
            HStack(spacing: 0){
                Text("\(solvedPaper.correctAnswers.count)")
                    .font(.largeTitle, weight: .black)
                Text("/")
                    .font(.largeTitle, weight: .light)
                Text("\(solvedPaper.allAnswers.count)")
                    .font(.largeTitle, weight: .black)
            }
        }
    }
    
    private var percentageWidget: some View {
        HStack(spacing: 0) {
            Text("Percentage: ")
                .font(.headline, weight: .light)
            HStack(spacing: 0) {
                Text(String(format:"%.1f", calculatedPercentage))
                    .font(.title2, weight: .black)
                Text(" %")
                    .font(.headline, weight: .regular)
            }
        }
    }
    
    private var gradeWidget: some View {
        HStack(spacing: 0) {
            Text("Grade: ")
                .font(.headline, weight: .light)
            Text(calculatedGrade)
                .font(.title2, weight: .black)
        }
    }
    
    private var pieChartWidget: some View {
        PieChart(colors: [.green, .pink, .yellow], values: [solvedPaper.correctAnswers.count, solvedPaper.incorrectAnswers.count, 10])
            .border(Color.black.opacity(0.5), width: 1, cornerRadius: .infinity)
            .overlay(
                Circle()
                    .frame(width: 250, height: 250)
                    .foregroundColor(.primaryInverted)
                    .border(Color.black.opacity(0.8), width: 1, cornerRadius: .infinity)
            )
            .shadow(radius: 5)
    }
    
    private var pieChartLegend: some View {
        VStack(alignment: .leading) {
            HStack {
                Color.green.clipShape(Circle())
                    .frame(width: 10, height: 10)
                Text("Correct answers:")
                    .italic()
                    .font(.subheadline, weight: .regular)
                Text("\(solvedPaper.correctAnswers.count)")
                    .fontWeight(.bold)
            }
            
            HStack {
                Color.pink.clipShape(Circle())
                    .frame(width: 10, height: 10)
                Text("Incorrect answers:")
                    .italic()
                    .font(.subheadline, weight: .regular)
                Text("\(solvedPaper.incorrectAnswers.count)")
                    .fontWeight(.bold)
            }
            
            HStack {
                Color.yellow.clipShape(Circle())
                    .frame(width: 10, height: 10)
                Text("Unattempted:")
                    .italic()
                    .font(.subheadline, weight: .regular)
                Text("\(solvedPaper.unsolvedAnswers.count)")
                    .fontWeight(.bold)
            }
        }
    }
    
}


struct MCQSolvedView_Previews: PreviewProvider {
    static var previews: some View {
        MCQSolvedView(Binding.constant(SolvedPaper(answers: [Answer].exampleAnswers, correctAnswers: [Answer].exampleCorrectAnswers)))
    }
}



struct BarView: View {
    let value: CGFloat
    let maxValue: CGFloat
    
    init(value: Int, maxValue: Int){
        self.value = CGFloat(value)
        self.maxValue = CGFloat(maxValue)
    }
    
    var body: some View {
        GeometryReader { screen in
            ZStack(alignment: .leading) {
                Capsule()
                    .foregroundColor(.black)
                    .frame(width: screen.size.width, height: screen.size.height)
                    
                Capsule()
                    .foregroundColor(.green)
                    .frame(width: (value*screen.size.width/maxValue <= screen.size.height ? screen.size.height : value*screen.size.width/maxValue) - 6*value/maxValue)
                    .padding(3)
                    .overlay(Text("\(Int(value))").font(.caption))
            }
        }
    }
}

struct PieChart: View {
    var colors: [Color] = [Color.green, Color.red, Color.blue, Color.yellow]
    var values: [Int] = [2, 4, 6, 20]
    var angles: [Angle] {
        let sum: CGFloat = CGFloat(values.reduce(0, +))
        let mappedAngles: [Angle] = values.map {
            Angle.degrees(CGFloat($0)*360/sum)
        }
        
        return mappedAngles
    }
    var anglesWithOffset: [Angle] {
        var mappedAnglesWithOffset: [Angle] = []
        var angleOffset: Angle = .degrees(0)
        
        for i in 0..<angles.count {
            mappedAnglesWithOffset.append(angles[i] + angleOffset)
            angleOffset += angles[i]
        }
        
        return mappedAnglesWithOffset
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<colors.count){ key in
                Sector(startAngle: .degrees(0), endAngle: anglesWithOffset[key], clockwise: true)
                    .foregroundColor(colors[key])
                    .zIndex(-Double(key))
            }
        }
    }
}

struct Sector: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        
        return path
    }
}


struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        return path
    }
}


func save(_ solved: SolvedPaper){
    
}
