//
//  ContentView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() { 
            RecordsView()
                .tabItem {
                    Image(systemName: "record.circle")
                    Text("Records")
                }
            NotesView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Notes")
                }
            LearnView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Learn")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
            AboutView()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
        }
    }
}

#Preview {
    ContentView()
}
