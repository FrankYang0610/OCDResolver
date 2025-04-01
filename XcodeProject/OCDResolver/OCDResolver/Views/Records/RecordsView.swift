//
//  OverviewView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI
import Charts

struct RecordsView : View {
    let chartCapacity                                   = 14
    let chartXAxisLabelsCount                           = 5
    let chartFilterOptions                              = [("ALL",          "All Records"),
                                                           ("INDEX",        "OCD Index"),
                                                           ("DISTRESSED",   "Distressed"),
                                                           ("ANXIOUS",      "Anxious"),
                                                           ("NEUTRAL",      "Neutral"),
                                                           ("HAPPY",        "Happy")]
                                                        // chart filter == records filter
    
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedChartFilter              = "ALL"
    @State private var addingNewEvent                   = false
    @State private var isSettingsViewShowing            = false
    @State private var isExpandedApplicationStatistics  = false
    @State private var isExpandedTrend                  = false
    @ObservedObject var dataManager                     = DataManager.shared
    @ObservedObject var profileManger                   = ProfileManager.shared

    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    recordsChart                        // Records chart
                    applicationData                     // Notifications and statistics
                    todayData                           // Today's data
                    pastSevenDaysData                   // Past 7 days' data
                    pastData                            // Other past data
                    Spacer()                            // Extra space
                        .frame(height: 80)
                        .listRowBackground(Color.clear) // Clear the default background color
                }
                .navigationTitle("Records")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            isSettingsViewShowing.toggle()
                        }) {
                            Image(systemName: "gear")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            addingNewEvent.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $addingNewEvent) {
                AddingNewRecordView()
            }
            .sheet(isPresented: $isSettingsViewShowing) {
                SettingsView()
            }
            
            quickRecord                                 // Quick record
        }
    } 
    
    var recordsChart: some View {
        VStack {
            Text("Recent Two Weeks")
                .font(.title2)
                .bold()
                .padding(.top, 10)
            
            Chart(getFullRecentStatistics(dailyStatistics: dataManager.dailyStatistics)) { statistic in
                let counts = statistic.counts
                let index = statistic.index

                // Bar Mark, Line Mark and Mixed
                if selectedChartFilter == "ALL" {       // selectedChartFilter == "ALL"
                    ForEach(MentalState.allCases, id: \.self) { state in
                        if let count = counts[state] {
                            BarMark(
                                x: .value("Date", statistic.date),
                                y: .value("Times", count)
                            )
                            .foregroundStyle(by: .value("Mental State", state.rawValue))
                            .shadow(color: state.color.opacity(0.3), radius: 2, x: 0, y: 2)
                        }
                    }
                }
                else if selectedChartFilter == "INDEX" {
                    LineMark(
                        x: .value("Date", statistic.date),
                        y: .value("Times", index)
                    )
                    //.foregroundStyle(by: .value("Mental State", selectedState.rawValue))
                    //.shadow(color: selectedState.color.opacity(0.3), radius: 2, x: 0, y: 2)
                    .interpolationMethod(.monotone)
                    .symbol(Circle())
                } else {                                // selectedChartFilter == "DISTRESSED" || "ANXIOUS" || "NEUTRAL" || "HAPPY"
                    if let selectedState = getStateFromLabel(from: selectedChartFilter) {
                        if let count = counts[selectedState] {
                            LineMark(
                                x: .value("Date", statistic.date),
                                y: .value("Times", count)
                            )
                            .foregroundStyle(by: .value("Mental State", selectedState.rawValue))
                            .shadow(color: selectedState.color.opacity(0.3), radius: 2, x: 0, y: 2)
                            .interpolationMethod(.monotone)
                            .symbol(Circle())
                        }
                    }
                }
            }
            .chartForegroundStyleScale([
                MentalState.distressed.rawValue:    MentalState.distressed.color,
                MentalState.anxious.rawValue:       MentalState.anxious.color,
                MentalState.neutral.rawValue:       MentalState.neutral.color,
                MentalState.happy.rawValue:         MentalState.happy.color
            ])
            .chartXAxis {
                AxisMarks(values: .stride(by: .day,
                                          count: chartCapacity / chartXAxisLabelsCount)) { value in
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            // .chartScrollableAxes(.horizontal)
            .padding(.bottom, 5)
            
            Picker("Records Filter", selection: $selectedChartFilter) {
                ForEach(chartFilterOptions, id: \.0) { option, optionText in
                    Text(optionText).tag(option)
                }
            }
            .padding(.top, 10)
            
            if selectedChartFilter == "INDEX" {
                Text("The OCD Index is calculated based on your records, with each mental state assigned a weight. The OCD Index is the weighted sum of your records, based on the weight of their respective mental states.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 10)
            }
        }
    }
    
    var applicationData: some View {
        Section("App notifications and statistics") {
            if profileManger.profile.username.isEmpty || profileManger.profile.currentOCDSymptoms.isEmpty {
                HStack {
                    Image(systemName: "lightbulb")
                    Text("Please update your personal profile.")
                }
            }
            
            DisclosureGroup(isExpanded: $isExpandedApplicationStatistics) {
                HStack {
                    Text("Records count")
                        .bold()
                    Spacer()
                    Text(String(dataManager.getRecordsCount()))
                } // HStack
                
                HStack {
                    Text("Days count")
                        .bold()
                    Spacer()
                    Text(String(dataManager.getDaysCount()))
                } // HStack
            } label: {
                HStack {
                    Text("Average records")
                        .bold()
                    Spacer()
                    Text(String(format: "%.2f", dataManager.getAverageDailyRecords()) + "/day")
                }
            } 
            
            DisclosureGroup(isExpanded: $isExpandedTrend) {
                HStack {
                    // let trendIndex: Double? = TrendHelper.getTrendIndex(statistics: dataManager.dailyStatistics)
                    let trendIndex: Double? = TrendHelper.getTrendIndex(statistics: getFullRecentStatistics(dailyStatistics: dataManager.dailyStatistics))
                    
                    Text("Slope")
                    Spacer()
                    Text((trendIndex != nil)
                         ? (String(format: "%.2f", trendIndex!) + "/day")
                         : "Unavailable")
                }
                
                Text("The trend is calculated using a Linear Least Squares Fit based on the OCD Indexes from the recent two weeks. To view your OCD Index graph, select the 'OCD Index' option in the Records Filter.")
            } label: {
                HStack {
                    // let trendLabel = TrendHelper.getTrendLabel(statistics: dataManager.dailyStatistics)
                    let trendLabel = TrendHelper.getTrendLabel(statistics: getFullRecentStatistics(dailyStatistics: dataManager.dailyStatistics))
                    
                    Text("Trend")
                        .bold()
                    Spacer()
                    Text(trendLabel.text)
                        .foregroundColor(trendLabel.color)
                }
            }
        }
    }
    
    var todayData: some View {
        createDataSection(title: "Today") { event in
            Calendar.current.startOfDay(for: event.date) == Calendar.current.startOfDay(for: Date())
        }
    }
    
    var pastSevenDaysData: some View {
        createDataSection(title: "Past 7 days") { event in
            let startOfToday = Calendar.current.startOfDay(for: Date())
            let startOfSevenDaysAgo = Calendar.current.startOfDay(for: Date().addingTimeInterval(-7 * 86400))
            return Calendar.current.startOfDay(for: event.date) < startOfToday &&
                   Calendar.current.startOfDay(for: event.date) >= startOfSevenDaysAgo
        }
    }
    
    var pastData: some View {
        createDataSection(title: "Much earlier") { event in
            Calendar.current.startOfDay(for: event.date) <=
            Calendar.current.startOfDay(for: Date().addingTimeInterval(-7 * 86400))
        }
    }
    
    var quickRecord: some View {
        VStack {
            Spacer()
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle((colorScheme == .light) ? Color.white : Color(UIColor.systemGray6))
                .frame(height: 80)
                .shadow(radius: 5)
                .overlay(
                    VStack {
                        Text("Quick Record")
                            .multilineTextAlignment(.center)
                            .bold()
                        
                        Spacer()
                        
                        HStack {
                            ForEach(MentalState.allCases, id: \.self) { state in
                                Button {
                                    UIImpactFeedbackGenerator(style: .medium)
                                        .impactOccurred()
                                    dataManager.addRecord(date: Date(),
                                                          mentalState: state,
                                                          notes: "")
                                } label: {
                                    Text(state.emoji)
                                        .font(.title)
                                        .multilineTextAlignment(.center)
                                }

                                if state != MentalState.allCases.last {
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                )
                .padding()
        }
    }
    
    // This method generates the last `chartCapacity` days' daily statistics.
    // This method will automatically fill in the missing dates with a default `DailyStatistic` object.
    func getFullRecentStatistics(dailyStatistics: [DailyStatistic]) -> [DailyStatistic] {
        let today = Calendar.current.startOfDay(for: Date())
        
        let lastChartCapacityDays = (0 ..< chartCapacity).compactMap { dayOffset -> Date? in
            Calendar.current.date(byAdding: .day, value: -dayOffset, to: today)
        }.reversed()
        
        let statisticsByDate = Dictionary(uniqueKeysWithValues: dailyStatistics.map { ($0.date, $0) })
        
        let chartStatistics = lastChartCapacityDays.map { date -> DailyStatistic in
            if let existingStatistic = statisticsByDate[date] {
                return existingStatistic
            } else {
                return DailyStatistic(date: date,
                                      counts: Dictionary(uniqueKeysWithValues: MentalState.allCases.map { ($0, 0) })
                )
            }
        }
        
        return chartStatistics
    }
    
    func getStateFromLabel(from chartOption: String) -> MentalState? {
        switch chartOption {
        case "DISTRESSED": return .distressed
        case "ANXIOUS": return .anxious
        case "NEUTRAL": return .neutral
        case "HAPPY": return .happy
        default: return nil
        }
    }
    
    func showingDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func createDataSection(title: String, filter: @escaping (Record) -> Bool) -> some View {
        let filteredRecords = dataManager.records.filter(filter)
        guard !filteredRecords.isEmpty else {
            return AnyView(EmptyView())
        }
        
        return AnyView(
            Section(title) {
                ForEach(filteredRecords) { record in
                    NavigationLink {
                        RecordDetailsView(record: record)
                    } label: {
                        HStack {
                            Text(record.mentalState.emoji)
                                .bold()
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) {
                                Text(record.mentalState.rawValue)
                                    .bold()
                                Text(showingDate(date: record.date))
                            } // VStack
                            
                            Spacer()
                            
                            if !record.note.isEmpty {
                                Image(systemName: "note.text")
                            }
                        }
                        .padding(2)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            dataManager.deleteRecord(id: record.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        )
    }
}

#Preview {
    RecordsView()
}
