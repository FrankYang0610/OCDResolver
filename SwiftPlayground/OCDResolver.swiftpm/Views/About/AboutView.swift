//
//  AboutView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct AboutView : View {
    var body: some View {
        NavigationStack {
            List {
                Section("About the author") {
                    HStack {
                        Text("Author")
                        Spacer()
                        Text("Frank Yang")
                    }
                    .bold()
                    
                    Link("Contact", destination: URL(string: "mailto:frankyang0610@icloud.com")!)
                    
                    Link("GitHub Profile", destination: URL(string: "https://github.com/FrankYang0610")!)
                }
                
                Section("Brief introduction") {
                    DocumentationsManager.documentations["BRIEF_INTRODUCTION"]
                }
                
                /*
                Section("Aim of the project") {
                    DocumentationsManager.documentations["AIM_OF_THE_PROJECT"]
                }
                 */
            }
            .navigationTitle("About")
        }
    }
}

#Preview {
    AboutView()
}
