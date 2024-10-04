//
//  ActivityView.swift
//  A1
//
//  Created by Francis Z on 30/8/2024.
//

import SwiftUI
import SwiftData

enum DayOption: String, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
}

struct ScheduleView: View {
    @State private var selectedOption: DayOption = .monday
    @Environment(\.modelContext) var modelContext
    @Query var activities: [ActivityRecord]
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let cardBackgroundColor = Color(red: 36/255, green: 50/255, blue: 71/255)
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(.all)
            
            VStack(alignment: .center, spacing: 20) {
                Text("Scheduled Activities")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                
                SchedulePicker(selectedOption: $selectedOption)
                    .padding(.bottom, 10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(activities.filter { $0.day == selectedOption.rawValue }, id: \.self) { activity in
                        ActivitySection(activity: activity, cardBackgroundColor: cardBackgroundColor, textColor: textColor)
                    }
                }
            }
            .padding(20)
        }
    }
}

struct SchedulePicker: View {
    @Binding var selectedOption: DayOption
    let options = DayOption.allCases
    
    var body: some View {
        Picker("Day", selection: $selectedOption) {
            ForEach(options, id: \.self) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
}

struct ActivitySection: View {
    var activity: ActivityRecord
    var cardBackgroundColor: Color
    var textColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(activity.day)
                .font(.headline)
                .foregroundColor(textColor)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(activity.activityName) @ \(activity.location)")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                    Text(activity.time)
                        .font(.caption)
                        .foregroundColor(textColor.opacity(0.7))
                }
                Spacer()
            }
            .padding()
            .background(cardBackgroundColor)
            .cornerRadius(10)
        }
        .padding(.bottom, 10)
    }
}

// Preview
struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
            .modelContainer(for: ActivityRecord.self)
    }
}
