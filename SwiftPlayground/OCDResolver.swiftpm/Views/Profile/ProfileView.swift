//
//  ProfileView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct ProfileView : View {
    @Environment(\.editMode) var editMode
    @ObservedObject var profileManager          = ProfileManager.shared
    @State private var draftProfile             = Profile.defaultProfile
    
    var body: some View {
        NavigationStack {
            VStack { 
                if editMode?.wrappedValue == .inactive {
                    ProfileInformationView(profile: $profileManager.profile)
                } else {
                    ProfileEditorView(profile: $draftProfile)
                        .onAppear() {
                            draftProfile = profileManager.profile
                        } // .onAppear
                        .onDisappear() {
                            profileManager.profile = draftProfile
                            profileManager.updateUserProfileData()
                        }
                }
            }
            .navigationTitle((editMode?.wrappedValue == .inactive) ? "Profile" : "")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if editMode?.wrappedValue == .active {
                        Button (action: {
                            draftProfile = profileManager.profile
                            editMode?.animation().wrappedValue = .inactive
                        }) {
                            Text("Cancel")
                            .bold()
                            .foregroundStyle(Color.red)
                        }
                    } 
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if editMode?.wrappedValue == .inactive {
                        Button (action: {
                            editMode?.animation().wrappedValue = .active
                        }) {
                            Text("Edit")
                            .bold()
                            .foregroundStyle(Color.blue)
                        }
                    } else {
                        Button (action: {
                            editMode?.animation().wrappedValue = .inactive
                        }) {
                            Text("Done")
                            .bold()
                            .foregroundStyle(Color.blue)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
