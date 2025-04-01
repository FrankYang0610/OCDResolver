//
//  DocumentationView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct DocumentationView : View {
    let title: String
    let content: AnyView
    
    var body: some View {
        List {              // For better reading
            content
        }
        .navigationTitle(title)
        // .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DocumentationView(title: "Hello World!", content: AnyView(
        Text("Hello World!")
    ))
}
