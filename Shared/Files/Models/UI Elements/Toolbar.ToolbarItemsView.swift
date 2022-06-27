//
// Copyright (c) Purav Manot
//

import SwiftUI
import SwiftUIX

extension Toolbar {
    struct ItemsView: View {
        @EnvironmentObject var applicationStore: ApplicationStore
        
        @Environment(\.presentationMode) var presentView
        
        @Binding var minimized: Bool
        @Binding var testMode: Bool
        @Binding var timerShowing: Bool
        @Binding var paperSelection: CambridgePaperType
        
        @Binding var markschemeShowing: Bool
        @Binding var answerOverlayShowing: Bool
        @Binding var datasheetShowing: Bool
        @Binding var flashcardCreationSheetShowing: Bool
        
        var body: some View {
            HStack {
                if testMode {
                    Button {
                        withAnimation(.spring()) {
                            testMode.toggle()
                            answerOverlayShowing = false
                            minimized = false
                        }
                    } label: {
                        Image(systemName: .stopCircleFill)
                            .font(.title2)
                    }
                    .frame(width: 30)
                    
                    Button {
                        withAnimation {
                            timerShowing.toggle()
                        }
                    } label: {
                        Image(systemName: timerShowing ? .stopwatchFill : .stopwatch)
                            .font(.title2)
                    }
                    .frame(width: 30)
                } else {
                    SymbolButton("arrow.left.circle.fill"){
                        presentView.dismiss()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.title)
                    .frame(width: 30)
                    
                    if !minimized {
                        Group {
                            Picker("", selection: $paperSelection){
                                Text("QP")
                                    .tag(CambridgePaperType.questionPaper)
                                Text("MS")
                                    .tag(CambridgePaperType.markScheme)
                                Text("DATA")
                                    .tag(CambridgePaperType.datasheet)
                            }
                            .frame(width: 140)
                            .pickerStyle(SegmentedPickerStyle())
                            
                            Spacer()
                            
                            Button(action: {
                                flashcardCreationSheetShowing.toggle()
                            }){
                                Image(systemName: .rectangleStackBadgePlus)
                                    .font(.title2)
                            }
                            .frame(width: 30)
                            
                            SymbolButton("bookmark", onToggle: "bookmark.fill"){
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.title2, weight: .regular)
                            .frame(width: 30)
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    minimized = true
                                    testMode.toggle()
                                    answerOverlayShowing.toggle()
                                    markschemeShowing = false
                                    datasheetShowing = false
                                }
                            }){
                                Image(systemName: .playCircleFill)
                                    .font(.title)
                            }
                        }
                    } else {
                        Group {
                            Button(action: {
                                withAnimation(.spring()){
                                    minimized.toggle()
                                }
                            }){
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .opacity(minimized ? 1 : 0)
                            }
                            .frame(width: 30)
                        }
                    }
                }
            }
            .foregroundColor(.label)
            .padding(6)
        }
    }
}
