//
//  CreditsView.swift
//  Papers
//
//  Created by Purav Manot on 30/12/21.
//

import SwiftUIX

struct CreditsView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                Section("Developers"){
                    Row(name: "Purav Manot", contributions: ["Lead developer  |", "Frontend  |", "Backend"])
                    Row(name: "Vatsal Manot", contributions: ["Consultant developer  |", "Debugging"])
                }
                Section("Testers"){
                    Row(name: "Oindrilla Sinha", contributions: ["UX Design  |", "Testing"])
                }
            }
            .navigationTitle("Contributors")
            
            Text("Made with ♡")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}

extension CreditsView {
    private struct Row: View {
        let name: String
        let contributions: [String]
        
        var body: some View {
            VStack(alignment: .leading){
                Text(name)
                    .font(.title2, weight: .heavy)
                    .foregroundColor(.pink)
                    .padding(.vertical, 10)
                HStack {
                    ForEach(contributions, id: \.self){ contribution in
                        Text(contribution)
                            .font(.caption, weight: .bold)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(5)
        }
    }
}
