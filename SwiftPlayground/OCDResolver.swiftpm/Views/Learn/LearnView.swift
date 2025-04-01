//
//  LearnView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct LearnView : View {
    var body: some View {
        NavigationStack {
            List {
                Section("OCD Evaluation") {
                    ocdEvaluation
                }
                Section("Documentations about OCD") {
                    documentations
                }
                Section("Documentations about the project") {
                    briefIntroduction
                    welcomeGuide
                    aimOfTheProject
                }
            }
            .navigationTitle("Learn")
        }
    }
    
    var ocdEvaluation: some View {
        Text("There are currently no available OCD Evaluation Questionaires.")
    }
    
    var documentations: some View {
        ForEach(DocumentationsManager.documentationsList, id: \.self) { title in
            NavigationLink {
                DocumentationView(title: title,
                                  content: DocumentationsManager.documentations[title]
                                  ?? DocumentationsManager.unavailableDocumentationView)
            } label: {
                Text(title)
            }
        } 
    }
    
    var briefIntroduction: some View {
        NavigationLink {
            DocumentationView(title: "Brief Introduction",
                              content: DocumentationsManager.documentations["BRIEF_INTRODUCTION"]!)
        } label: {
            Text("Brief introduction to this app")
        }
    }
    
    var aimOfTheProject: some View {
        NavigationLink {
            DocumentationView(title: "Aim of the project", content: DocumentationsManager.documentations["AIM_OF_THE_PROJECT"]!)
        } label: {
            Text("Aim of the project")
        }
    }
    
    var welcomeGuide: some View {
        NavigationLink {
            GuideScreenView(isFirstLaunch: .constant(false))
        } label: {
            Text("Welcome Guide")
        }
    }
}

#Preview {
    LearnView()
}
