//
//  ProfileEditorView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI
import PhotosUI

struct ProfileEditorView : View {
    @State private var selectedImage: UIImage?  = nil
    @State private var isPickerPresented        = false
    @Binding var profile: Profile
    
    var body: some View {
        List {
            HStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Text("Avatar")
                        .foregroundStyle(Color.gray)
                }
                
                Spacer()
                
                Button(action: {
                    isPickerPresented = true
                }) {
                    Text("Change")
                        .bold()
                }
                .alert("Feature Unavailable", isPresented: $isPickerPresented) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Sorry, this feature is currently unavailable.")
                }
                /*
                .sheet(isPresented: $isPickerPresented, content: {
                    // select avatar
                })
                 */
            }
            
            HStack {
                Text("Username")
                    .bold()
                Divider()
                TextField("Your username", text: $profile.username)
            }
            
            VStack {
                Text("Current compulsory or ritual behaviors")
                    .multilineTextAlignment(.center)
                    .bold()
                TextEditor(text: $profile.currentOCDSymptoms)
                    .frame(height: 200)
            }
        } 
    }
}

#Preview {
    ProfileEditorView(profile: .constant(Profile.defaultProfile))
}
