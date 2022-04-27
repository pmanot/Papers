//
//  LoadingView.swift
//  Papers (iOS)
//
//  Created by Purav Manot on 03/01/22.
//

import SwiftUI

struct LoadingView: View {
    let time: TimeInterval = 2
    @Binding var loading: Bool
    @State private var value: CGFloat = 10
    var body: some View {
        VStack(alignment: .center) {
            Text("Loading papers..")
                .font(.title3, weight: .light)
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: 250, height: 20)
                    .border(Color.secondary, cornerRadius: .infinity)
                Capsule()
                    .frame(width: value, height: 20)
                    .foregroundColor(.pink)
            }
        }
        .onAppear {
            DispatchQueue.global(qos: .userInteractive).async {
                withAnimation(.easeInOut(duration: time)) {
                    value = 250
                    DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + .seconds(Int(time))){
                        loading.toggle()
                    }
                }
            }
        }
        
    }
}

