//
//  ActivityData.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 4/10/2024.
//
import SwiftUI
import SwiftData

struct ActivitiesView: View {
    @State private var selectedView = "Today"
    @State private var selectedActivity: String? = nil
    
    @Environment(\.modelContext) private var context
    @Query private var scheduledActivities: [ActivityRecord] // Querying scheduled activities
    
    let locations = [
        "Griffith Park", "Venice Beach", "Echo Park", "Santa Monica Pier", "Runyon Canyon",
        "Hollywood Walk of Fame", "The Grove", "Dodger Stadium", "Malibu Beach", "Los Angeles Zoo"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with "Activities" title and "Today" segmented tab
            HStack {
                Text("Activities")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Picker("", selection: $selectedView) {
                    Text("Today").tag("Today")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
            }
            .padding(.horizontal)
            
            // Weather Information
            VStack {
                Image(systemName: "cloud.fill")
                    .font(.system(size: 60))
                    .padding()
                Text("20°C")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Melbourne, Australia")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Divider()
                    .padding(.horizontal)
                
                // Weather Details
                HStack {
                    WeatherDetailView(icon: "wind", label: "9 km/h", value: "Wind")
                    Spacer()
                    WeatherDetailView(icon: "humidity", label: "41%", value: "Humidity")
                    Spacer()
                    WeatherDetailView(icon: "drop.fill", label: "0 mm", value: "Precipitation")
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
            
            // Activities Now
            VStack(alignment: .leading) {
                Text("Activities Now")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                HStack {
                    ActivityButton(activity: "Biking", condition: "Good Conditions", selectedActivity: $selectedActivity)
                    Spacer()
                    ActivityButton(activity: "Walking", condition: "Good Conditions", selectedActivity: $selectedActivity)
                    Spacer()
                    ActivityButton(activity: "Running", condition: "Moderate Conditions", selectedActivity: $selectedActivity)
                }
            }
            .padding(.horizontal)
            
            // Add Activity to Schedule Button moved above Next Scheduled Activity
            Button(action: addActivity) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Activity to Schedule")
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedActivity != nil ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.horizontal)
            }
            .disabled(selectedActivity == nil)
            
            // Next Scheduled Activity Section
            VStack(alignment: .leading) {
                Text("Next Scheduled Activity")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                if let scheduledActivity = scheduledActivities.first {
                    HStack {
                        ScheduledActivityView(day: scheduledActivity.day, time: scheduledActivity.time, activity: "\(scheduledActivity.activityName) @ \(scheduledActivity.location)", condition: "Good Conditions")
                        
                        Spacer()
                        
                        // Remove Button
                        Button(action: {
                            removeActivity(scheduledActivity)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Ensure the button doesn't interfere with row selections
                    }
                } else {
                    Text("No activities scheduled")
                        .foregroundColor(.gray)
                        .padding(.leading)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.vertical)
    }
    
    private func addActivity() {
        // Remove existing scheduled activities
        for activity in scheduledActivities {
            context.delete(activity)
        }
        
        if let activity = selectedActivity {
            let location = locations.randomElement() ?? "Unknown Location"
            let newActivity = ActivityRecord(activityName: activity, location: location, day: "TODAY", time: "7 AM")
            
            context.insert(newActivity) // Save the new activity to SwiftData context
            
            selectedActivity = nil // Clear selected activity after scheduling
        }
    }
    
    private func removeActivity(_ activity: ActivityRecord) {
        context.delete(activity)
    }
}

// Subview for Weather Details
struct WeatherDetailView: View {
    var icon: String
    var label: String
    var value: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(label)
                .fontWeight(.bold)
            Text(value)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// Subview for Activity Buttons
struct ActivityButton: View {
    var activity: String
    var condition: String
    @Binding var selectedActivity: String?
    
    var body: some View {
        VStack {
            Text(activity)
                .fontWeight(.bold)
            Text(condition)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 120, height: 60)
        .background(selectedActivity == activity ? Color.blue : Color(.systemGray6))
        .cornerRadius(10)
        .foregroundColor(selectedActivity == activity ? .white : .primary)
        .onTapGesture {
            // Toggle selection
            if selectedActivity == activity {
                selectedActivity = nil // Deselect if already selected
            } else {
                selectedActivity = activity // Select the activity
            }
        }
    }
}

// Subview for Scheduled Activity
struct ScheduledActivityView: View {
    var day: String
    var time: String
    var activity: String
    var condition: String
    
    var body: some View {
        HStack {
            VStack {
                Text(day)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(activity)
                    .fontWeight(.bold)
                Text(condition)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

// Preview
struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
            .modelContainer(for: ActivityRecord.self)
    }
}
