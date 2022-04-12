//
// Copyright (c) Purav Manot
//

import SwiftUIX
import PDFKit
import SwiftUI

struct PapersView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    @State private var showingSortOptionSheet: Bool = false
    @State var sortType: SortType = .sortByYear
    @State var innerSortType: SortType = .sortByMonth
    
    var body: some View {
        ListView(papersDatabase: applicationStore.papersDatabase, sortBy: $sortType, sortInsideBy: $innerSortType)
            .navigationTitle("Papers")
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $showingSortOptionSheet){
                PaperSortOptionView(sortBy: $sortType, sortInsideBy: $innerSortType)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        showingSortOptionSheet.toggle()
                    }){
                        HStack(spacing: 5) {
                            Image(systemName: .sliderHorizontal3)
                        }
                        .foregroundColor(.pink)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
    }
}


struct PapersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PapersView()
                .environmentObject(ApplicationStore())
                .preferredColorScheme(.dark)
        }
    }
}

extension PapersView {
    struct ListView: View {
        @ObservedObject var papersDatabase: PapersDatabase
        @Binding var sortBy: SortType
        @Binding var sortInsideBy: SortType

        var sortedBundles: [SortArgument : [CambridgePaperBundle]] {
            sortBundles(papersDatabase.paperBundles, sortBy: sortBy)
        }
        
        var body: some View {
            List {
                switch sortBy {
                    case .sortByYear:
                        ForEach(PapersDatabase.years, id: \.self) { year in
                            Section("20\(year)") {
                                InnerSortView(bundles: sortedBundles[SortArgument.year(year)] ?? [], sortBy: $sortInsideBy)
                            }
                        }
                        .listRowBackground(Color.background)
                    case .sortByMonth:
                        ForEach(PapersDatabase.months, id: \.self) { month in
                            Section("\(month.rawValue)") {
                                InnerSortView(bundles: sortedBundles[SortArgument.month(month)] ?? [], sortBy: $sortInsideBy)
                            }
                        }
                        .listRowBackground(Color.background)
                    case .sortBySubject:
                        ForEach(PapersDatabase.subjects, id: \.self) { subject in
                            Section("\(subject.rawValue)") {
                                InnerSortView(bundles: sortedBundles[SortArgument.subject(subject)] ?? [], sortBy: $sortInsideBy)
                            }
                        }
                        .listRowBackground(Color.background)
                    case .sortByPaperNumber:
                        ForEach(PapersDatabase.paperNumbers, id: \.self) { number in
                            Section("Paper \(number.rawValue)") {
                                InnerSortView(bundles: sortedBundles[SortArgument.paperNumber(number)] ?? [], sortBy: $sortInsideBy)
                            }
                        }
                        .listRowBackground(Color.background)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    struct BoxView: View {
        var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], content: {
                    ForEach(0..<40){ _ in
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder()
                            .frame(width: 70, height: 70)
                    }
                })
            }
        }
    }
    
    enum ViewMode {
        case boxStyle
        case listStyle
    }
}


extension PapersView.ListView {
    struct InnerSortView: View {
        let bundles: [CambridgePaperBundle]
        @Binding var sortBy: SortType
        
        var sortedBundles: [SortArgument : [CambridgePaperBundle]] {
            sortBundles(bundles, sortBy: sortBy)
        }
        
        var body: some View {
            switch sortBy {
                case .sortByYear:
                    ForEach(PapersDatabase.years, id: \.self) { year in
                        DisclosureGroup(content: {
                            ForEach(sortedBundles[SortArgument.year(year)] ?? [], id: \.metadata.code){ bundle in
                                Row(paperBundle: bundle)
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }, label: {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("20\(year)")
                                    .font(.title3, weight: .heavy)
                                
                                Text("\(sortedBundles[SortArgument.year(year)]!.count) papers")
                                    .font(.subheadline, weight: .regular)
                                    .foregroundColor(.secondaryLabel)
                            }
                            .padding()
                        })
                    }
                case .sortByMonth:
                    ForEach(PapersDatabase.months, id: \.self) { month in
                        DisclosureGroup(content: {
                            ForEach(sortedBundles[SortArgument.month(month)] ?? [], id: \.metadata.code){ bundle in
                                Row(paperBundle: bundle)
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }, label: {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("\(month.rawValue)")
                                    .font(.title3, weight: .heavy)
                                
                                Text("\(sortedBundles[SortArgument.month(month)]!.count) papers")
                                    .font(.subheadline, weight: .regular)
                                    .foregroundColor(.secondaryLabel)
                            }
                            .padding()
                        })
                    }
                case .sortBySubject:
                    ForEach(PapersDatabase.subjects, id: \.self) { subject in
                        DisclosureGroup(content: {
                            ForEach(sortedBundles[SortArgument.subject(subject)] ?? [], id: \.metadata.code){ bundle in
                                Row(paperBundle: bundle)
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }, label: {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(subject.rawValue)
                                    .font(.title3, weight: .heavy)
                                    
                                Text("\(sortedBundles[SortArgument.subject(subject)]!.count) papers")
                                    .font(.subheadline, weight: .regular)
                                    .foregroundColor(.secondaryLabel)
                            }
                            .padding()
                        })
                    }
                case .sortByPaperNumber:
                    ForEach(PapersDatabase.paperNumbers, id: \.self) { number in
                        DisclosureGroup(content: {
                            ForEach(sortedBundles[SortArgument.paperNumber(number)] ?? [], id: \.metadata.code){ bundle in
                                Row(paperBundle: bundle)
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }, label: {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Paper \(number.rawValue)")
                                    .font(.title3, weight: .heavy)
                                Text("\(sortedBundles[SortArgument.paperNumber(number)]!.count) papers")
                                    .font(.subheadline, weight: .regular)
                                    .foregroundColor(.secondaryLabel)
                            }
                            .padding()
                        })
                    }
            }
        }
    }
}

extension PapersView.ListView.InnerSortView {
    struct Row: View {
        let paperBundle: CambridgePaperBundle
        
        var body: some View {
            NavigationLink(destination: PaperContentsView(bundle: paperBundle)) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(paperBundle.metadata.subject.rawValue)")
                            .font(.title3, weight: .black)
                        
                        Text(paperBundle.metadata.questionPaperCode)
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                    }
                    
                    HStack {
                        Text("\(paperBundle.metadata.month.compact())")
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                        
                        Text("20\(paperBundle.metadata.year)")
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                        
                        Text("Paper \(paperBundle.metadata.paperNumber.rawValue)")
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                        
                        Text("Variant \(paperBundle.metadata.paperVariant.rawValue)")
                            .foregroundColor(.primary)
                            .modifier(TagTextStyle())
                    }
                    
                    if paperBundle.metadata.paperType == .questionPaper {
                        HStack {
                            Text("\(paperBundle.metadata.numberOfQuestions) questions  |  \(paperBundle.questionPaper!.pages.count) pages")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundColor(.secondary)
                            
                            if paperBundle.metadata.paperNumber == .paper1 && paperBundle.markScheme != nil {
                                if !paperBundle.markScheme!.metadata.answers.isEmpty {
                                    Group {
                                        Image(systemName: .aCircleFill)
                                        Image(systemName: .bCircleFill)
                                        Image(systemName: .cCircleFill)
                                        Image(systemName: .dCircleFill)
                                    }
                                    .font(.headline)
                                    .frame(width: 15)
                                }
                            }
                        }
                        
                    } else {
                        Text("Markscheme")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(.secondary)
                            .padding(6)
                    }
                    
                }
                .padding(5)
                
            }
        }
    }
}

struct TagTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.secondary)
            .font(.caption)
            .padding(6)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary, lineWidth: 0.5))
    }
}


func sortBundles(_ paperBundles: [CambridgePaperBundle], sortBy: SortType) -> [SortArgument : [CambridgePaperBundle]] {
    switch sortBy {
        case .sortByYear:
            var seperatedBundles: [SortArgument : [CambridgePaperBundle]] = [:]
            for year in PapersDatabase.years {
                seperatedBundles[.year(year)] = []
            }
            for bundle in paperBundles.sorted(by: { $0.metadata.year >= $1.metadata.year }) {
                seperatedBundles[.year(bundle.metadata.year)]!.append(bundle)
            }
            return seperatedBundles
            
        case .sortByMonth:
            var seperatedBundles: [SortArgument : [CambridgePaperBundle]] = [:]
            for month in PapersDatabase.months {
                seperatedBundles[.month(month)] = []
            }
            for bundle in paperBundles {
                seperatedBundles[.month(bundle.metadata.month)]!.append(bundle)
            }
            return seperatedBundles
            
        case .sortBySubject:
            var seperatedBundles: [SortArgument : [CambridgePaperBundle]] = [:]
            for subject in PapersDatabase.subjects {
                seperatedBundles[.subject(subject)] = []
            }
            for bundle in paperBundles {
                seperatedBundles[.subject(bundle.metadata.subject)]!.append(bundle)
            }
            return seperatedBundles
            
            
        case .sortByPaperNumber:
            var seperatedBundles: [SortArgument : [CambridgePaperBundle]] = [:]
            for number in PapersDatabase.paperNumbers {
                seperatedBundles[.paperNumber(number)] = []
            }
            for bundle in paperBundles {
                seperatedBundles[.paperNumber(bundle.metadata.paperNumber)]!.append(bundle)
            }
            return seperatedBundles
           
    }
    
}
