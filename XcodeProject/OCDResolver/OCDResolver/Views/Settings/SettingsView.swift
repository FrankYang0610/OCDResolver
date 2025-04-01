//
//  ConfigureView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct SettingsView : View {
    @State private var removeAllDataAlert = false
    @ObservedObject var dataManager = DataManager.shared
    
    var body: some View {
        NavigationStack { // Grand Title
            List {
                Section("Notification settings") {
                    Text("Notification settings unavailable.")
                }
                
                Section("Remove all records") {
                    Button(action: {
                        removeAllDataAlert = true
                    }) {
                        Text("Remove all records")
                            .foregroundStyle(Color.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .alert(isPresented: $removeAllDataAlert) {
            Alert(
                title: Text("Confirm deletion?")
                    .font(.title),
                message: Text("This operation cannot be reversed.")
                    .font(.body),
                primaryButton: .cancel(Text("Cancel")),
                secondaryButton: .destructive(Text("Confirm")) {
                    dataManager.removeAllRecords()
                }
            )
        } 
    }
}

#Preview {
    SettingsView()
}
