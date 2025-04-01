//
//  AddingNewEventView.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation
import SwiftUI

struct AddingNewRecordView : View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedMentalState: MentalState     = .anxious
    @State private var currentDate: Date                    = Date()
    @State private var writtenNotes: String                 = ""
    @ObservedObject var dataManager                         = DataManager.shared
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: Calendar.current.startOfDay(for: Date()))!
        let max = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!
        return min...max
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .bold()
                        .foregroundStyle(Color.red)
                } // Button
                
                Spacer()
                
                Text("Add a New Record")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    dataManager.addRecord(date: currentDate,
                                          mentalState: selectedMentalState,
                                          notes: writtenNotes)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    dismiss()
                }) {
                    Text("Done")
                        .bold()
                }
            } // HStack
            .ignoresSafeArea(.all)
            .padding(.horizontal, 15)
            
            List {
                VStack {
                    Text("Mental state")
                        .bold()
                        .padding(5)
                    Picker("selectedMentalState", selection: $selectedMentalState) {
                        ForEach(MentalState.allCases, id:\.self) { state in
                            switch state {
                            case .distressed:
                                Text("🥵 Distressed")
                                    .bold()
                                    .foregroundStyle(Color.red)
                            case .anxious:
                                Text("😰 Anxious")
                                    .bold()
                                    .foregroundStyle(Color.orange)
                            case .neutral:
                                Text("😐 Neutral")
                                    .bold()
                                    .foregroundStyle(Color.blue)
                            case.happy:
                                Text("🥳 Happy")
                                    .bold()
                                    .foregroundStyle(Color.purple)
                            } // switch
                        } // ForEach
                    } // Picker
                    .pickerStyle(.wheel)
                    .frame(height: 150)         // Set frame height (= max height)
                    .clipped()                  // Prevent content from overflowing boundaries
                }
                
                HStack {
                    Text("Date")
                        .bold()
                    Spacer()
                    DatePicker(selection: $currentDate, in: dateRange, displayedComponents: .date) { }
                }
                
                HStack {
                    Text("Time")
                        .bold()
                    Spacer()
                    DatePicker(selection: $currentDate, displayedComponents: .hourAndMinute) { }
                }
                
                VStack {
                    Text("Additional notes")
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(5)
                    
                    TextEditor(text: $writtenNotes)
                        .frame(height: 150)
                }
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    AddingNewRecordView()
}
