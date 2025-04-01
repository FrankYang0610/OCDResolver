//
//  SentimentAnalyzer.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import NaturalLanguage

class SentimentAnalyzer {
    static func getSentimentScore(note: String) -> Float {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = note
        if let sentimentScoreObject = tagger.tag(at: note.startIndex, unit: .paragraph, scheme: .sentimentScore).0,
           let sentimentScore = Float(sentimentScoreObject.rawValue) {
            return sentimentScore
        } else {
            return 0.0
        }
    }
    
    static func getOverallSentimentScore(notes: [String]) -> Float {
        if notes.isEmpty {
            return 0.0
        }
        
        var totalSentimentScore: Float = 0.0
        for note in notes {
            totalSentimentScore += getSentimentScore(note: note)
        }
        
        return totalSentimentScore / Float(notes.count)
    }
    
    static func getSentimentScoreLabel(score: Float) -> String {
        if score > 0 {
            return "Positive"
        } else if score < 0 {
            return "Negative"
        } else {
            return "Neutral"
        }
    }
}
