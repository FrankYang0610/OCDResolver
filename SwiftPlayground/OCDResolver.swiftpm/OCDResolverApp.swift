//
//  OCDResolverApp.swift
//
//  Created by Frank Yang.
//

import SwiftUI

@main
struct OCDResolverApp: App {
    @AppStorage("isFirstLaunch") private var isFirstLaunch                  = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {        // First launch
                GuideScreenView(isFirstLaunch: $isFirstLaunch)
                    .onAppear {
                        createDataFiles()
                    }
            } else {                                                        // Not first launch
                ContentView()
                    .onAppear {
                        loadData()
                    }
            }
        }
    }
    
    func loadData() {
        DataManager.shared.loadRecordsJSON()
        DataManager.shared.loadDailyStatisticsJSON()
        ProfileManager.shared.loadUserProfileData()
    }
    
    func createDataFiles() {
        DataManager.shared.updateRecordsJSON()                              // Create new JSON file
        DataManager.shared.updateDailyStatisticsJSON()                      // Create new JSON file
        ProfileManager.shared.updateUserProfileData()                       // Create new JSON file
    }
}
