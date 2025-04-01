//
//  Profile.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

/// This file implements all related classes related to 'Personal Profile', including:
/// - `Profile` - the profile
/// - `ProfileManager` - the singleton interface to SwiftUI

import Foundation
import SwiftUI

struct Profile: Codable, Identifiable {
   var id = UUID()
   
   var username: String
   var avatar: String                  // avatar file name
   var currentOCDSymptoms: String
    
   static let defaultProfile = Profile(username: "", avatar: "avatar", currentOCDSymptoms: "")
}


class ProfileManager: ObservableObject {
   @MainActor static let shared = ProfileManager()
   @Published var profile: Profile = Profile.defaultProfile
   
   func loadUserProfileData() {
      let userProfiles: [Profile] = JSONManager.load(filename: "Profile.json")
      if !userProfiles.isEmpty {
         profile = userProfiles[0]
      }
   }

   func updateUserProfileData() {
      JSONManager.update(data: [profile], filename: "Profile.json")
   }
}
