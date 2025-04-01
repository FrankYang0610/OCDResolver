//
//  EventDetailsView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct RecordDetailsView : View {
    @State var record: Record
    
    var body: some View {
        VStack {
            ScrollView {
                Text(record.mentalState.emoji)
                    .font(.system(size: 50))
                    .bold()
                    .padding(.bottom, 10)
                
                Text(showingDate(date: record.date))
                    .bold()
                
                Text(record.mentalState.rawValue)
                    .font(.title)
                    .padding(.bottom, 20)
                
                if !record.note.isEmpty {
                    Divider()
                        .padding(.horizontal, 50)
                    
                    Text("Notes")
                        .bold()
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    Text(record.note)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .bottom, .trailing], 20)
                } // if
                
                Divider()
                    .padding(.horizontal, 50)
                
                Text("Which shown above is your real feeling at that time. ")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .padding(.top, 20)
                Text("Please don't try to change it.")
                    .bold()
            }
        }
    }
    
    func showingDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
        return dateFormatter.string(from: date)
    } 
}

#Preview {
    RecordDetailsView(record: Record(date: Date(), mentalState: .anxious, note: "I'm anxious."))
}
