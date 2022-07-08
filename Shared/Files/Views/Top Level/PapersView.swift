//
// Copyright (c) Purav Manot
//

import Combine
import PDFKit
import SwiftUI
import SwiftUIX
 
struct PapersView: View {
    @EnvironmentObject var applicationStore: ApplicationStore
    
    @State private var showingSortOptionSheet: Bool = false
    @State private var searchText = ""
    @State private var sortType: PapersListSectionType = .byYear
    @State private var innerSortType: PapersListSectionType = .byMonth
    @State var expanded: Bool = false
    
    var body: some View {
        ListView(database: applicationStore.papersDatabase, sortBy: $sortType, sortInsideBy: $innerSortType, searchText: $searchText, expanded: $expanded)
            .navigationTitle("Papers")
            .navigationViewStyle(StackNavigationViewStyle())
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu {
                        PaperSortOptionView(sortBy: $sortType, sortInsideBy: $innerSortType)
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: .sliderHorizontal3)
                        }
                        .foregroundColor(.pink)
                    }
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
        @ObservedObject var database: PapersDatabase
        @Binding var sortBy: PapersListSectionType
        @Binding var sortInsideBy: PapersListSectionType
        @Binding var searchText: String
        @Binding var expanded: Bool
        @State private var selectedSubject: CambridgeSubject = .physics
        @State private var selectedPaperNumber: CambridgePaperNumber = .paper4
        @State private var searchResults: [CambridgePaperBundle] = []
        
        init(database: PapersDatabase, sortBy: Binding<PapersListSectionType>, sortInsideBy: Binding<PapersListSectionType>, searchText: Binding<String>, expanded: Binding<Bool>) {
            self.database = database
            self._sortBy = sortBy
            self._sortInsideBy = sortInsideBy
            self._searchText = searchText
            self._expanded = expanded
        }

        var sortedBundles: [PapersListSection: [CambridgePaperBundle]] {
            database.paperBundles.group(by: sortBy)
        }
        
        var sections: [PapersListSection] {
            switch sortBy {
                case .byYear:
                    return PapersDatabase.years.map(PapersListSection.year)
                case .byMonth:
                    return PapersDatabase.months.map(PapersListSection.month)
                case .bySubject:
                    return PapersDatabase.subjects.map(PapersListSection.subject)
                case .byPaperNumber:
                    return PapersDatabase.paperNumbers.map(PapersListSection.paperNumber)
            }
        }
    
        var body: some View {
            List {
                if searchText.isEmpty {
                    ForEach(sections, id: \.self) { section in
                        if let bundles = sortedBundles[section] {
                            Section {
                                InnerSortView(bundles: bundles, sortBy: $sortInsideBy, searchText: searchText, expanded: $expanded)
                            } header: {
                                switch section {
                                    case .year(let year):
                                        Text(String(year))
                                            .font(.title2, weight: .semibold)
                                    case .month(let month):
                                        Text("\(month.compact())")
                                            .font(.title3, weight: .semibold)
                                    case .subject(let subject):
                                        Text(subject.rawValue)
                                            .font(.title2, weight: .semibold)
                                    case .paperNumber(let paperNumber):
                                        Text("Paper \(paperNumber.rawValue)")
                                            .font(.title2, weight: .semibold)
                                }
                            }
                        }
                    }
                } else {
                    Section {
                        TagPicker(PapersDatabase.subjects, id: \.self, selection: $selectedSubject) { subject in
                            Text(subject.rawValue)
                        }
                        .frame(height: 40)
                        TagPicker(PapersDatabase.paperNumbers, id: \.self, selection: $selectedPaperNumber) { paperNumber in
                            Text("Paper \(paperNumber.rawValue)")
                        }
                        .frame(height: 40)
                    }
                    
                    Section("Showing \(searchResults.count) results for \"\(searchText)\"") {
                        ForEach(searchResults.filter(filter), id: \.id) { bundle in
                            Row(paperBundle: bundle, searchText: searchText)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .withChangePublisher(for: searchText) { searchTextPublisher in
                searchTextPublisher.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main).sink { text in
                    Task(priority: .userInitiated) {
                        let searchResults = database.paperBundles.filter { bundle in
                            bundle.metadata.rawText.match(text)
                        }
                        
                        await MainActor.run {
                            self.searchResults = searchResults
                        }
                    }
                }
            }
        }
        
        private func filter(_ bundle: CambridgePaperBundle) -> Bool {
            return bundle.metadata.details.number == selectedPaperNumber && bundle.metadata.subject == selectedSubject
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


enum PapersListSectionType {
    case byYear
    case byMonth
    case bySubject
    case byPaperNumber
}

enum PapersListSection: Hashable {
    case year(_ i: Int)
    case month(_ i: CambridgePaperMonth)
    case subject(_ i: CambridgeSubject)
    case paperNumber(_ i: CambridgePaperNumber)
}

extension PapersView.ListView {
    struct InnerSortView: View {
        let bundles: [CambridgePaperBundle]
        
        @Binding var sortBy: PapersListSectionType
        let searchText: String
        @Binding var expanded: Bool
                
        var sections: [PapersListSection] {
            switch sortBy {
                case .byYear:
                    return PapersDatabase.years.map(PapersListSection.year)
                case .byMonth:
                    return PapersDatabase.months.map(PapersListSection.month)
                case .bySubject:
                    return PapersDatabase.subjects.map(PapersListSection.subject)
                case .byPaperNumber:
                    return PapersDatabase.paperNumbers.map(PapersListSection.paperNumber)
            }
        }
        
        var itemsPerSection: [PapersListSection: [CambridgePaperBundle]] {
            bundles.group(by: sortBy)
        }

        var body: some View {
            let itemsPerSection = self.itemsPerSection

            ForEach(sections, id: \.self) { (section: PapersListSection) in
                if let items = itemsPerSection[section] {
                    DisclosureGroup {
                        ForEach(items, id: \.metadata.code){ bundle in
                            Row(paperBundle: bundle, searchText: searchText)
                                .buttonStyle(PlainButtonStyle())
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            switch section {
                                case .year(let year):
                                    Text(String(year))
                                        .font(.title2, weight: .semibold)
                                case .month(let month):
                                    Text("\(month.compact())")
                                        .font(.title3, weight: .semibold)
                                case .subject(let subject):
                                    Text(subject.rawValue)
                                        .font(.title2, weight: .semibold)
                                case .paperNumber(let paperNumber):
                                    Text("Paper \(paperNumber.rawValue)")
                                        .font(.title2, weight: .semibold)
                            }
                            
                            Text("\(items.count) papers")
                                .font(.subheadline, weight: .regular)
                                .foregroundColor(.secondaryLabel)
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
        }
    }
}

struct Row: View {
    let paperBundle: CambridgePaperBundle
    let searchText: String?
    
    
    
    var body: some View {
        NavigationLink(destination: PaperContentsView(bundle: paperBundle, search: searchText)) {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(paperBundle.metadata.subject.rawValue)")
                        .font(.title3, weight: .semibold)
                    Text(paperBundle.metadata.kind.rawValue.uppercased())
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.systemGray2)
                        .cornerRadius(15)
                        .shadow(radius: 0.5)
                    
                }
                
                HStack {
                    Text("\(paperBundle.metadata.month.compact())")
                        .modifier(TagTextStyle(color: Color.blue))
                    
                    Text(String(paperBundle.metadata.year))
                        .modifier(TagTextStyle(color: Color.blue))
                        
                    
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
            
        }
    }
}

extension Array where Element == CambridgePaperBundle {
    func group(by sectionType: PapersListSectionType) -> [PapersListSection: [CambridgePaperBundle]] {
        switch sectionType {
            case .byYear:
                return group(by: { PapersListSection.year($0.metadata.year) }).mapValues({ $0.sorted(by: { $0.metadata.year > $1.metadata.year }) })
            case .byMonth:
                return group(by: { PapersListSection.month($0.metadata.month) })
            case .bySubject:
                return group(by: { PapersListSection.subject($0.metadata.subject) })
            case .byPaperNumber:
                return group(by: { PapersListSection.paperNumber($0.metadata.paperNumber) })
        }
    }
}
