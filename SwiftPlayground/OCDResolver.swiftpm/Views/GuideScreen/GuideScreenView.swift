//
//  GuideScreenView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct GuideScreenView : View {
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)                                   // requires further adjustments
            
            (Text("Welcome to\n") + Text("OCD Resolver").bold())
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
            
            Spacer()
            
            ForEach(DocumentationsManager.guideItems) { item in
                GuideItemUI(symbolName: item.symbolName,
                            symbolColor: item.symbolColor,
                            title: item.title,
                            content: item.content)
            }
            
            Spacer()
            
            if isFirstLaunch {
                Button(action: {
                    isFirstLaunch = false
                }) {
                    Text("Continue")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 40)
                }
            }
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    GuideScreenView(isFirstLaunch: .constant(true))
}
