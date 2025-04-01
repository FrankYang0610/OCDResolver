//
//  Feature.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct GuideItemUI : View {
    var symbolName: String          // systemName of the Image
    var symbolColor: Color
    var title: String
    var content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: symbolName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(symbolColor)
            
            Spacer()
                .frame(width: 5)
            
            VStack(spacing: 5) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(content)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: UIScreen.main.bounds.width * 0.55)
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    GuideItemUI(symbolName: "lightbulb",
                symbolColor: .blue,
                title: "Lorem Ipsum",
                content: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                """)
}
