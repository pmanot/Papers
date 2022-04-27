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
                            Section("\(String(year))") {
                                InnerSortView(bundles: sortedBundles[SortArgument.year(year)] ?? [], sortBy: $sortInsideBy)
                            }
                        }
                        .listRowBackground(Color.primaryInverted)
                    case .sortByMonth:
                        ForEach(PapersDatabase.months, id: \.self) { month in
                            Section("\(month.rawValue)") {
                                InnerSortView(bundles: sortedBundles[SortArgument.month(month)] ?? [], sortBy: $sortInsideBy)
                            }
                        }
                        .listRowBackground(Color.primaryInverted)
                    case .sortBySubject:
                        ForEach(PapersDatabase.subjects, id: \.self) { subject in
                            Section("\(subject.rawValue)") {
                                InnerSortView(bundles: sortedBundles[SortArgument.subject(subject)] ?? [], sortBy: $sortInsideBy)
                            }
                        }
                        .listRowBackground(Color.primaryInverted)
                    case .sortByPaperNumber:
                        ForEach(PapersDatabase.paperNumbers, id: \.self) { number in
                            Section("Paper \(number.rawValue)") {
                                InnerSortView(bundles: sortedBundles[SortArgument.paperNumber(number)] ?? [], sortBy: $sortInsideBy)
                            }
                        }
                        .listRowBackground(Color.primaryInverted)
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
                            .font(.title3, weight: .bold)
                        
                        Text(paperBundle.metadata.kind.rawValue)
                            .modifier(TagTextStyle())
                    }
                    
                    HStack {
                        Text("\(paperBundle.metadata.month.compact())")
                            .modifier(TagTextStyle())
                        
                        Text(String(paperBundle.metadata.year))
                            .modifier(TagTextStyle())
                        
                        Text("Paper \(paperBundle.metadata.paperNumber.rawValue)")
                            .modifier(TagTextStyle())
                        
                        Text("Variant \(paperBundle.metadata.paperVariant.rawValue)")
                            .modifier(TagTextStyle())
                    }
                    
                    
                            Text("\(paperBundle.metadata.numberOfQuestions) questions  |  \(paperBundle.questionPaper!.pages.count) pages")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundColor(.secondary)
                }
                .padding(5)
                
            }
        }
    }
}

struct TagTextStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        switch colorScheme {
            case .dark:
                content
                    .foregroundColor(.primary)
                    .font(.caption)
                    .padding(7)
                    .background(Color.accentColor.opacity(0.8).cornerRadius(8))
                    .shadow(radius: 0.5)
            default:
                content
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(7)
                    .background(Color.accentColor.opacity(0.8).cornerRadius(8))
                    .shadow(radius: 0.5)
        }
        
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
