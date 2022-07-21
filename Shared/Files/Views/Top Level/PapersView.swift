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
        .navigationViewStyle(.stack)
        .previewDevice(PreviewDevice(rawValue: "iPad mini (6th generation)"))
        .previewDisplayName("MiniPad")
        
        NavigationView {
            PapersView()
                .environmentObject(ApplicationStore())
                .preferredColorScheme(.dark)
        }
        .navigationViewStyle(.stack)
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (5th generation)"))
        .previewDisplayName("MaxiPad")
    }
}


extension PapersView {
    struct ListView: View {
        @ObservedObject var database: PapersDatabase
        @Binding var sortBy: PapersListSectionType
        @Binding var sortInsideBy: PapersListSectionType
        @Binding var searchText: String
        @State private var selectedSubject: CambridgeSubject = .physics
        @State private var selectedPaperNumber: CambridgePaperNumber = .paper4
        @State private var searchResults: [CambridgePaperBundle] = []
        @Environment(\.userInterfaceIdiom) var userInterface
        private var viewMode: ViewMode {
            if userInterface == .mac || userInterface == .pad {
                return .boxStyle
            } else {
                return .listStyle
            }
        
        }
        
        init(database: PapersDatabase, sortBy: Binding<PapersListSectionType>, sortInsideBy: Binding<PapersListSectionType>, searchText: Binding<String>, expanded: Binding<Bool>) {
            self.database = database
            self._sortBy = sortBy
            self._sortInsideBy = sortInsideBy
            self._searchText = searchText
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
            switch viewMode {
                case .boxStyle:
                    if searchText.isEmpty {
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ForEach(sections, id: \.self) { section in
                                    if let bundles = sortedBundles[section] {
                                        Section {
                                            InnerSortView(database: database, bundles: bundles, sortBy: $sortInsideBy, searchText: searchText, viewMode: viewMode)
                                        } header: {
                                            switch section {
                                                case .year(let year):
                                                    Text(String(year))
                                                        .font(.title, weight: .semibold)
                                                        .foregroundColor(.secondary)
                                                case .month(let month):
                                                    Text("\(month.compact())")
                                                        .font(.title, weight: .semibold)
                                                        .foregroundColor(.secondary)
                                                case .subject(let subject):
                                                    Text(subject.rawValue)
                                                        .font(.title, weight: .semibold)
                                                        .foregroundColor(.secondary)
                                                case .paperNumber(let paperNumber):
                                                    Text("Paper \(paperNumber.rawValue)")
                                                        .font(.title, weight: .semibold)
                                                        .foregroundColor(.secondary)
                                            }
                                                
                                                
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    } else {
                        Section {
                            ScrollView {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 180))], spacing: 20){
                                    ForEach(searchResults.filter(filter), id: \.id) { bundle in
                                        Box(database: database, paperBundle: bundle, searchText: searchText)
                                            .swipeActions {
                                                Button(action: {
                                                    if !database.savedPaperCodes.contains(bundle.questionPaperCode) {
                                                        database.savePaper(bundle: bundle)
                                                    } else {
                                                        database.removePaper(bundle: bundle)
                                                    }
                                                    
                                                }, label: {
                                                    if !database.savedPaperCodes.contains(bundle.questionPaperCode) {
                                                        Label("Save", systemImage: .bookmark)
                                                    } else {
                                                        Label("Unsave", systemImage: .xmark)
                                                    }
                                                })
                                                
                                            }
                                    }
                                }
                            }
                        } header: {
                            VStack(alignment: .leading) {
                                TagPicker(PapersDatabase.subjects, id: \.self, selection: $selectedSubject) { subject in
                                    Text(subject.rawValue)
                                }
                                .frame(height: 30)
                                .id("subject")
                                
                                TagPicker(PapersDatabase.paperNumbers, id: \.self, selection: $selectedPaperNumber) { paperNumber in
                                    Text("Paper \(paperNumber.rawValue)")
                                }
                                .frame(height: 30)
                                .id("paper")
                                
                            }
                            
                            Text("Showing \(searchResults.count) results for \"\(searchText)\"")
                        }
                    }
                    
                default:
                    List {
                        if searchText.isEmpty {
                            ForEach(sections, id: \.self) { section in
                                if let bundles = sortedBundles[section] {
                                    Section {
                                        InnerSortView(database: database, bundles: bundles, sortBy: $sortInsideBy, searchText: searchText, viewMode: viewMode)
                                    } header: {
                                        switch section {
                                            case .year(let year):
                                                Text(String(year))
                                                    .font(.title2, weight: .semibold)
                                            case .month(let month):
                                                Text("\(month.compact())")
                                                    .font(.title2, weight: .semibold)
                                            case .subject(let subject):
                                                Text(subject.rawValue)
                                                    .font(.title2, weight: .semibold)
                                            case .paperNumber(let paperNumber):
                                                Text("Paper \(paperNumber.rawValue)")
                                                    .font(.title, weight: .semibold)
                                        }
                                    }
                                }
                            }
                        } else {
                            Section {
                                ForEach(searchResults.filter(filter), id: \.id) { bundle in
                                    Row(database: database, paperBundle: bundle, searchText: searchText)
                                        .swipeActions {
                                            Button(action: {
                                                if !database.savedPaperCodes.contains(bundle.questionPaperCode) {
                                                    database.savePaper(bundle: bundle)
                                                } else {
                                                    database.removePaper(bundle: bundle)
                                                }
                                                
                                            }, label: {
                                                if !database.savedPaperCodes.contains(bundle.questionPaperCode) {
                                                    Label("Save", systemImage: .bookmark)
                                                } else {
                                                    Label("Unsave", systemImage: .xmark)
                                                }
                                            })
                                            
                                        }
                                }
                            } header: {
                                TagPicker(PapersDatabase.subjects, id: \.self, selection: $selectedSubject) { subject in
                                    Text(subject.rawValue)
                                }
                                .frame(height: 30)
                                .id("subject")
                                
                                TagPicker(PapersDatabase.paperNumbers, id: \.self, selection: $selectedPaperNumber) { paperNumber in
                                    Text("Paper \(paperNumber.rawValue)")
                                }
                                .frame(height: 30)
                                .id("paper")
                                
                                Text("Showing \(searchResults.count) results for \"\(searchText)\"")
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
        }
        
        private func filter(_ bundle: CambridgePaperBundle) -> Bool {
            return bundle.metadata.details.number == selectedPaperNumber && bundle.metadata.subject == selectedSubject
        }
    }
}


enum PapersListSectionType {
    case byYear
    case byMonth
    case bySubject
    case byPaperNumber
}

enum ViewMode {
    case boxStyle
    case listStyle
}

enum PapersListSection: Hashable {
    case year(_ i: Int)
    case month(_ i: CambridgePaperMonth)
    case subject(_ i: CambridgeSubject)
    case paperNumber(_ i: CambridgePaperNumber)
}

extension PapersView.ListView {
    struct InnerSortView: View {
        @ObservedObject var database: PapersDatabase
        let bundles: [CambridgePaperBundle]
        @Binding var sortBy: PapersListSectionType
        let searchText: String
        let viewMode: ViewMode
                
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
                    if viewMode == .boxStyle {
                        BoxView(database: database, items: items, section: section)
                    } else {
                        ListView(database: database, items: items, section: section)
                    }
                }
            }
        }
        
    }
}

extension PapersView.ListView.InnerSortView {
    struct BoxView: View {
        @ObservedObject var database: PapersDatabase
        
        let items: [CambridgePaperBundle]
        let section: PapersListSection
        
        var body: some View {
            DisclosureGroup {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 20)], spacing: 20) {
                    ForEach(items, id: \.id){ bundle in
                        Box(database: database, paperBundle: bundle, searchText: nil)
                    }
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
                .foregroundColor(.primary)
                .padding(.vertical, 10)
            }
        }
    }
    
    struct ListView: View {
        @ObservedObject var database: PapersDatabase
        let items: [CambridgePaperBundle]
        let section: PapersListSection
        var body: some View {
            DisclosureGroup {
                ForEach(items, id: \.id){ bundle in
                    Row(database: database, paperBundle: bundle, searchText: nil)
                        .buttonStyle(PlainButtonStyle())
                        .swipeActions {
                            Button(action: {
                                if !database.savedPaperCodes.contains(bundle.questionPaperCode) {
                                    database.savePaper(bundle: bundle)
                                } else {
                                    database.removePaper(bundle: bundle)
                                }
                                
                            }, label: {
                                if !database.savedPaperCodes.contains(bundle.questionPaperCode) {
                                    Label("Save", systemImage: .bookmark)
                                } else {
                                    Label("Unsave", systemImage: .xmark)
                                }
                            })
                        }
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

struct Box: View {
    @ObservedObject var database: PapersDatabase
    let paperBundle: CambridgePaperBundle
    let searchText: String?
    
    var body: some View {
        NavigationLink(destination: PaperContentsView(bundle: paperBundle, search: searchText, database: database)) {
            GroupBox {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(paperBundle.metadata.subject.rawValue)")
                                .font(.title3, weight: .semibold)
                            Text(paperBundle.metadata.kind.rawValue.uppercased())
                                .font(.subheadline, weight: .semibold)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if !database.savedPaperCodes.contains(paperBundle.questionPaperCode) {
                                database.savePaper(bundle: paperBundle)
                            } else {
                                database.removePaper(bundle: paperBundle)
                            }
                            
                        }, label: {
                            Image(systemName: !database.savedPaperCodes.contains(paperBundle.questionPaperCode) ? .bookmark : .bookmarkFill)
                                .font(.title2)
                        })
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 5) {
                            Text("\(paperBundle.metadata.month.compact())")
                                .modifier(TagTextStyle(color: Color.blue))
                            
                            Text(String(paperBundle.metadata.year))
                                .modifier(TagTextStyle(color: Color.blue))
                        }
                        
                        HStack(spacing: 5) {
                            Text("Paper \(paperBundle.metadata.paperNumber.rawValue)")
                                .modifier(TagTextStyle())
                            
                            Text("Variant \(paperBundle.metadata.paperVariant.rawValue)")
                                .modifier(TagTextStyle())
                        }
                    }
                    
                    Divider()
                    
                    Text("\(paperBundle.metadata.numberOfQuestions) questions,  \(paperBundle.questionPaper!.pages.count) pages")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        
                }
            }
            .frame(minWidth: 180)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Row: View {
    @ObservedObject var database: PapersDatabase
    let paperBundle: CambridgePaperBundle
    let searchText: String?
    
    var body: some View {
        NavigationLink(destination: PaperContentsView(bundle: paperBundle, search: searchText, database: database)) {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(paperBundle.metadata.subject.rawValue)")
                        .font(.title3, weight: .semibold)
                    Text(paperBundle.metadata.kind.rawValue.uppercased())
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.systemGray)
                        .cornerRadius(15)
                        .shadow(radius: 0.5)
                    
                }
                
                HStack(spacing: 5) {
                    Text("\(paperBundle.metadata.month.compact())")
                        .modifier(TagTextStyle(color: Color.blue))
                    
                    Text(String(paperBundle.metadata.year))
                        .modifier(TagTextStyle(color: Color.blue))
                    
                    Text("Paper \(paperBundle.metadata.paperNumber.rawValue)")
                        .modifier(TagTextStyle())
                    
                    Text("Variant \(paperBundle.metadata.paperVariant.rawValue)")
                        .modifier(TagTextStyle())
                }
                
                
                Text("\(paperBundle.metadata.numberOfQuestions) questions,  \(paperBundle.questionPaper!.pages.count) pages")
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
