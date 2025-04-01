//
//  NoteRecordsView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct NotesView : View {
    @State private var isExpandedSentimentAnalysisInfo  = false
    @ObservedObject var dataManager                     = DataManager.shared
    
    var body: some View {
        NavigationStack {
            let recordsWithNote = dataManager.getAllRecordsWithNote()
            let overallSentimentScore = SentimentAnalyzer.getOverallSentimentScore(notes: recordsWithNote.map { $0.note })
            let overallSentimentLabel = SentimentAnalyzer.getSentimentScoreLabel(score: overallSentimentScore)
            
            List {
                if !recordsWithNote.isEmpty {
                    Section("Sentiment Analysis (Beta)") {
                        VStack {
                            Text("Average sentiment score of all notes:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(String(format: "%.2f", overallSentimentScore) + String(" (\(overallSentimentLabel))"))
                                .font(.title2)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                        
                        DisclosureGroup(isExpanded: $isExpandedSentimentAnalysisInfo) {
                            Text("""
                                 Swift's built-in NaturalLanguage framework is used to perform sentiment analysis on all your notes. The analyzer only support English texts. 
                                 
                                 You will receive a sentiment score ranging from -1 to 1. The closer it is to -1, the more negative your notes are; the closer it is to 1, the more positive your notes are. 0 indicates a neutral language.
                                 """)
                        } label: {
                            Text("What is this?")
                        }
                    }
                    
                    Section("All Notes") {
                        ForEach(recordsWithNote) { record in
                            HStack {
                                Text(record.note)
                                Spacer()
                                Divider()
                                Text(showingDate(date: record.date))
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                } else {
                    Text("""
                         Currently no notes have been found.
                         
                         When you add notes while adding a new record, the notes will be listed here.
                         
                         There is also a Beta version of Sentiment Analysis. It only supports notes in English.
                         """)
                }
            }
            .navigationTitle("Notes")
        }
    }
    
    func showingDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm \n MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    NotesView()
}
