//
//  Records.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

/// This file implements all related classes related to 'Records', including:
/// - `MentalState` - the mental state
/// - `Record` - the record
/// - `DailyStatistic` - the daily statistics
/// - `DataManager` - the singleton interface to SwiftUI

import Foundation
import SwiftUI              // Color

/// Mental States
enum MentalState: String, Codable, CaseIterable {
    case distressed         = "Distressed"
    case anxious            = "Anxious"
    case neutral            = "Neutral"
    case happy              = "Happy"
    
    /// The weight of each state
    /// Please also view the documentation
    var weight: Double {
        switch self {
        case .distressed:   return 0.4
        case .anxious:      return 0.3
        case .neutral:      return 0.2
        case .happy:        return 0.1
        }
    }
    
    /// The representative color of each mental state. This is useful when drawing charts.
    var color: Color {
        switch self {
        case .distressed:   return .red
        case .anxious:      return .orange
        case .neutral:      return .blue
        case .happy:        return .purple
        }
    }
    
    /// The representative emoji of each mental state. 
    var emoji: String {
        switch self {
        case .distressed:   return "🥵"
        case .anxious:      return "😰"
        case .neutral:      return "😐"
        case .happy:        return "🥳"
        }
    }
}


/// The main record class
struct Record: Hashable, Codable, Identifiable {
    var id = UUID()     // Universal identifier
    var date: Date
    var mentalState: MentalState
    var note: String
}


/// The daily statistics
/// This class keeps track of the count of each mental state for each day.
struct DailyStatistic: Codable, Identifiable {
    var id = UUID()     // Universal identifier
    var date: Date      // Starting of the day
    var counts: [MentalState: Int] = [:]
    
    // Calculate the index of the day based on the counts and the weights of each mental state
    var index: Double {
        var temp: Double = 0
        for (state, count) in counts {
            temp += state.weight * Double(count)
        }
        return temp
    }
}


class TrendHelper {
    private static func linearLeastSquaresFit(points: [(Double, Double)]) -> (k: Double, b: Double)? {
        guard points.count > 1 else { return nil }                                                      // At least two data points

        let n       = Double(points.count)
        let sumX    = points.reduce(0) { $0 + $1.0 }                                                    // ∑x
        let sumY    = points.reduce(0) { $0 + $1.1 }                                                    // ∑y
        let sumXY   = points.reduce(0) { $0 + $1.0 * $1.1 }                                             // ∑xy
        let sumX2   = points.reduce(0) { $0 + $1.0 * $1.0 }                                             // ∑x^2

        let denominator = n * sumX2 - sumX * sumX
        guard denominator != 0 else { return nil }                                                      // Denominator == 0

        let k = (n * sumXY - sumX * sumY) / denominator
        let b = (sumY - k * sumX) / n

        return (k, b)
    }
    
    static func getTrendIndex(statistics: [DailyStatistic]) -> Double? {
        guard statistics.count > 1 else { return nil }
        
        let points = statistics.enumerated().map { (index, stat) in
            return (Double(index), Double(stat.index))
        }
        
        return linearLeastSquaresFit(points: points)?.k
    }
    
    static func getTrendLabel(statistics: [DailyStatistic]) -> (text: String, color: Color) {
        if let k = getTrendIndex(statistics: statistics) {                                             
            if k > 0 {
                return ("Increasing", .red)
            } else if k < 0 {
                return ("Decreasing", .green)
            } else {
                return ("Stable", .primary)
            }
        } else {
            return ("Trend Unavailable", .primary)
        }
    }
}


/// The main records manager class
/// The singleton class
class DataManager: ObservableObject {
    @MainActor static let shared = DataManager()                                                                   // The Singleton instance
    
    @Published var records: [Record] = []
    @Published var dailyStatistics: [DailyStatistic] = []
    
    func getRecordsCount() -> Int {
        return records.count
    }
    
    func getDaysCount() -> Int {
        return dailyStatistics.count
    }
    
    func getAverageDailyRecords() -> Double {
        if getDaysCount() == 0 {
            return 0
        }
        return Double(getRecordsCount()) / Double(getDaysCount())
    }
    
    func sortRecords() {
        records.sort {
            ($0.date, $0.mentalState.weight) > ($1.date, $1.mentalState.weight)
        }
    }
    
    func getAllRecordsWithNote() -> [Record] {
        return records.filter { !$0.note.isEmpty }
    }
    
    func addRecord(date: Date, mentalState: MentalState, notes: String) {
        records.append(Record(date: date,
                              mentalState: mentalState,
                              note: notes))
        updateDailyStatistics(date: Calendar.current.startOfDay(for: date),
                              mentalState: mentalState,
                              isAdd: true, isDelete: false)
        
        sortRecords()                                                                                     // Sort
        updateRecordsJSON(); updateDailyStatisticsJSON()                                                 // Update JSON data
        
        records = records; dailyStatistics = dailyStatistics                                              // Trigger SwiftUI to refresh
    }

    func deleteRecord(id: UUID) {
        if let index = records.firstIndex(where: { $0.id == id }) {
            updateDailyStatistics(date: Calendar.current.startOfDay(for: records[index].date),
                                  mentalState: records[index].mentalState,
                                  isAdd: false, isDelete: true)
            records.remove(at: index)
        }
        
        sortRecords()                                                                                    // Sort
        updateRecordsJSON(); updateDailyStatisticsJSON()                                                 // Update JSON data
        
        records = records; dailyStatistics = dailyStatistics                                             // Trigger SwiftUI to refresh
    }

    func removeAllRecords() {
        records.removeAll(); dailyStatistics.removeAll()                                                 // Remove all data
        updateRecordsJSON(); updateDailyStatisticsJSON()                                                 // Update JSON data
        records = records; dailyStatistics = dailyStatistics                                             // Trigger SwiftUI to refresh
    }

    /// Update daily statistics data
    func updateDailyStatistics(date: Date, mentalState: MentalState, isAdd: Bool, isDelete: Bool) {     // one and only one of isAdd and isDelete should be true
        if let index = dailyStatistics.firstIndex(where: {
            Calendar.current.startOfDay(for: $0.date) == Calendar.current.startOfDay(for: date)
        }) {
            dailyStatistics[index].counts[mentalState]! += isAdd        ? 1 : 0
            dailyStatistics[index].counts[mentalState]! -= isDelete     ? 1 : 0
        } else {                                                                                        // The day didn't exist, we add a new statistics of the day
            var initialCounts = [MentalState: Int]()
            for state in MentalState.allCases {
                initialCounts[state] = (state == mentalState && isAdd)  ? 1 : 0
            }
            dailyStatistics.append(DailyStatistic(date: date,
                                                  counts: initialCounts))
        }
    }

    func loadRecordsJSON() {
        records = JSONManager.load(filename: "RecordsData.json")
    }

    func updateRecordsJSON() {
        JSONManager.update(data: records,
                           filename: "RecordsData.json")
    }

    func loadDailyStatisticsJSON() {
        dailyStatistics = JSONManager.load(filename: "DailyStatisticsData.json")
    }

    func updateDailyStatisticsJSON() {
        JSONManager.update(data: dailyStatistics,
                           filename: "DailyStatisticsData.json")
    }
}

