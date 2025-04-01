//
//  ProfileInformationView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI
import Combine

struct ProfileInformationView : View {
    @Binding var profile: Profile
    
    var body: some View {
        ScrollView {
            Avatar(image: Image(profile.avatar))
                .padding(10)
                
            Text(!profile.username.isEmpty
                 ? profile.username
                 : "User") // default username
                .bold()
                .font(.title)
            
            Divider()
            Spacer()
            Text("My compulsory or ritual behaviors")
                .bold()
                .padding(5)
            Text(profile.currentOCDSymptoms)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ProfileInformationView(profile: .constant(Profile.defaultProfile))
}
