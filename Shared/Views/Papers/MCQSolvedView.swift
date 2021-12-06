//
// Copyright (c) Purav Manot
//

import SwiftUI

struct MCQSolvedView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var solvedPaper: SolvedPaper!
    
    var calculatedPercentage: Double {
        Double(solvedPaper.correctAnswers.count)/Double(solvedPaper.allAnswers.count)*100
    }

    var correctPercentage: Double {
        Double(solvedPaper.correctAnswers.count)/Double(solvedPaper.correctAnswers.count + solvedPaper.incorrectAnswers.count)*100
    }
    
    var timeTaken: Double {
        solvedPaper.answers.map { $0.time ?? 0 }.reduce(0, +)
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
    
    init(_ solved: SolvedPaper){
        self._solvedPaper = Binding.constant(solved)
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
                        .frame(height: 1)
            
                    HStack(alignment: .firstTextBaseline) {
                        percentageWidget
                        Spacer()
                        gradeWidget
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                .border(Color.black, width: 0.3, cornerRadius: 10, antialiased: true)
                .padding()
                
                pieChartWidget
                
                SymbolButton("checkmark.circle.fill"){
                    save(solvedPaper, database: PapersDatabase())
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .font(.system(size: 45), weight: .light)
                .padding()
            }
            .padding()
            .edgesIgnoringSafeArea(.all)
            .foregroundColor(.primary)
        }
    }
}

extension MCQSolvedView {
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
    
    private var pieChart: some View {
        PieChart(colors: [.green, .pink, .yellow], values: [Double(solvedPaper.correctAnswers.count), Double(solvedPaper.incorrectAnswers.count), Double(solvedPaper.unsolvedAnswers.count)])
            .border(Color.black.opacity(0.5), width: 1, cornerRadius: .infinity)
            .overlay(
                Circle()
                    .frame(width: 250, height: 250)
                    .foregroundColor(.primaryInverted)
                    .border(Color.black.opacity(0.8), width: 1, cornerRadius: .infinity, antialiased: true)
            )
            .shadow(radius: 5)
    }
    
    private var pieChartLegend: some View {
        VStack(alignment: .leading) {
            HStack {
                Color.green.clipShape(Circle())
                    .frame(width: 10, height: 10)
                Text("Correct answers:")
                    .font(.caption, weight: .regular)
                Text("\(solvedPaper.correctAnswers.count)")
                    .font(.subheadline, weight: .heavy)
            }
            
            HStack {
                Color.pink.clipShape(Circle())
                    .frame(width: 10, height: 10)
                Text("Incorrect answers:")
                    .font(.caption, weight: .regular)
                Text("\(solvedPaper.incorrectAnswers.count)")
                    .font(.subheadline, weight: .heavy)
            }
            
            HStack {
                Color.yellow.clipShape(Circle())
                    .frame(width: 10, height: 10)
                Text("Unattempted:")
                    .font(.caption, weight: .regular)
                Text("\(solvedPaper.unsolvedAnswers.count)")
                    .font(.subheadline, weight: .heavy)
            }
        }
    }
    
    var pieChartWidget: some View {
        ZStack {
            pieChart
                .aspectRatio(1, contentMode: .fit)
            PieChart(colors: [.blue, .white], values: [timeTaken, (40*60)])
                .frame(width: 245, height: 245)
                .overlay(
                    Circle()
                        .frame(width: 220, height: 220)
                        .foregroundColor(.primaryInverted)
                        .border(Color.black.opacity(0.8), width: 0.5, cornerRadius: .infinity)
                )
            pieChartLegend
        }
    }
    
    var barChartWidget: some View {
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
    
    var miniSolvedPaperWidget: some View {
        HStack(alignment: .top) {
            barChartWidget
            
            VStack{
                HStack(spacing: 0){
                    Text("\(solvedPaper.correctAnswers.count)")
                        .font(.title2, weight: .black)
                    Text("/")
                        .font(.title, weight: .light)
                    Text("\(solvedPaper.allAnswers.count)")
                        .font(.largeTitle, weight: .black)
                }
                .padding(3)
                .border(.black, width: 0.5, cornerRadius: 8)
                .padding(.leading, 5)
                .padding(.vertical, 5)
            }
            
            
        }
        .padding()
        .border(Color.white, width: 0.5, cornerRadius: 10)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.primaryInverted).shadow(radius: 3))
    }
}


struct MCQSolvedView_Previews: PreviewProvider {
    static var previews: some View {
        MCQSolvedView(.constant(SolvedPaper.example))
    }
}



struct BarView: View {
    var color: Color
    let value: CGFloat
    let maxValue: CGFloat
    
    @State var width: CGFloat = 0
    
    init(_ color: Color = Color.green, value: Int, maxValue: Int){
        self.value = CGFloat(value)
        self.maxValue = CGFloat(maxValue)
        self.color = color
    }
    
    var body: some View {
        GeometryReader { screen in
            ZStack(alignment: .leading) {
                Capsule()
                    .foregroundColor(.black)
                    .frame(width: screen.size.width, height: screen.size.height)
                    
                Rectangle()
                    .cornerRadius(.infinity)
                    .foregroundColor(color)
                    .frame(width: width)
                    .padding(3)
            }
            .onAppear {
                let relativewidth = value/maxValue
                if value == 0 {
                    width = 0
                } else if relativewidth*screen.size.width <= (screen.size.height - 6) {
                    width = (screen.size.width - 6)
                } else {
                    width = relativewidth*screen.size.width
                }
            }
        }
    }
}

struct PieChart: View {
    var colors: [Color] = [Color.green, Color.red, Color.blue, Color.yellow]
    var values: [Double] = [2, 4, 6, 20]
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
    var axis: Axis = .horizontal
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        switch axis {
            case .horizontal:
                path.move(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            case .vertical:
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
        
        return path
    }
}


func save(_ solved: SolvedPaper, database: PapersDatabase){
    database.writeSolvedPaperData(solved)
}
