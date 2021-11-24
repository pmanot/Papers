//
//  MCQView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 23/11/21.
//

import SwiftUI

struct MCQView: View {
    @EnvironmentObject var papersDatabase: PapersDatabase
    var body: some View {
        ZStack(alignment: .bottom) {
            WrappedPDFView(pdf: PapersDatabase.exampleMCQ!)
                .background(Color.white)
            MCQAnswerOverlay()
                .padding(.bottom, 10)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MCQView_Previews: PreviewProvider {
    static var previews: some View {
        MCQView()
    }
}


struct MCQAnswerOverlay: View {
    @State var index: Int = 1
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("4")
                .foregroundColor(.primary)
                .font(.headline)
                .fontWeight(.bold)
                .frame(width: 35, height: 35)
                .background(Color.primaryInverted.cornerRadius(10))
                .border(.black, width: 1, cornerRadius: 10, style: .circular)
                .padding(3)
                .padding(.horizontal)
            
            HStack {
                Button(action: {}){
                    Text("A")
                        .foregroundColor(Color.primaryInverted)
                        .font(.title2)
                        .fontWeight(.black)
                        .frame(width: 48, height: 48)
                        .background(Circle())
                        .padding(2)
                        .border(Color.primary, width: 2, cornerRadius: .infinity, style: .circular)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 15)
                
                Button(action: {}){
                    Text("B")
                        .foregroundColor(Color.primaryInverted)
                        .font(.title2)
                        .fontWeight(.black)
                        .frame(width: 48, height: 48)
                        .background(Circle())
                        .padding(2)
                        .border(Color.primary, width: 2, cornerRadius: .infinity, style: .circular)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 15)
                
                Button(action: {}){
                    Text("C")
                        .foregroundColor(Color.primaryInverted)
                        .font(.title2)
                        .fontWeight(.black)
                        .frame(width: 48, height: 48)
                        .background(Circle())
                        .padding(2)
                        .border(Color.primary, width: 2, cornerRadius: .infinity, style: .circular)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 15)
                
                Button(action: {}){
                    Text("D")
                        .foregroundColor(Color.primaryInverted)
                        .font(.title2)
                        .fontWeight(.black)
                        .frame(width: 48, height: 48)
                        .background(Circle())
                        .padding(2)
                        .border(Color.primary, width: 2, cornerRadius: .infinity, style: .circular)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 15)
            }
            .padding(.vertical, 10)
            .background(Capsule().foregroundColor(.white).border(.black, width: 1, cornerRadius: .infinity, style: .circular))
        }
    }
}
