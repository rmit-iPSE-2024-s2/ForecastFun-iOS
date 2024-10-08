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
    @State private var selectedDay: DayOption = .monday
    @State private var weatherData: (temperature: String, wind: String, humidity: String, precipitation: String) = ("20°C", "9 km/h", "41%", "0 mm")
    
    @Environment(\.modelContext) private var context
    let locations = [
        "Griffith Park", "Venice Beach", "Echo Park", "Santa Monica Pier", "Runyon Canyon",
        "Hollywood Walk of Fame", "The Grove", "Dodger Stadium", "Malibu Beach", "Los Angeles Zoo"
    ]
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let cardBackgroundColor = Color(red: 36/255, green: 50/255, blue: 71/255)
    let highlightColor = Color.blue
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    
    var body: some View {
        VStack(spacing: 15) {
            // Header Section
            HStack {
                Text("Activities")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                
                Spacer()
                
                Picker("", selection: $selectedView) {
                    Text("Today").tag("Today")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
            }
            .padding(.horizontal)
            
            VStack(spacing: 5) {
                Image(systemName: "cloud.fill")
                    .font(.system(size: 40))
                    .foregroundColor(textColor)
                
                Text(weatherData.temperature)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                
                Text("Melbourne, Australia")
                    .font(.caption)
                    .foregroundColor(textColor.opacity(0.7))
                
                Divider()
                    .background(textColor.opacity(0.5))
                    .padding(.horizontal, 10)
                
                HStack {
                    WeatherDetailView(icon: "wind", label: weatherData.wind, value: "Wind", textColor: textColor)
                    Spacer()
                    WeatherDetailView(icon: "humidity", label: weatherData.humidity, value: "Humidity", textColor: textColor)
                    Spacer()
                    WeatherDetailView(icon: "drop.fill", label: weatherData.precipitation, value: "Precipitation", textColor: textColor)
                }
                .padding(.horizontal, 10)
            }
            .padding(10)
            .background(cardBackgroundColor)
            .cornerRadius(15)
            .padding(.horizontal)
            .onChange(of: selectedDay) { newDay in
                weatherData = getRandomWeatherData()
            }
            
            // Day Picker for scheduling
            VStack(alignment: .leading) {
                Text("Day")
                    .font(.headline)
                    .foregroundColor(textColor)
                    .padding(.bottom, 5)
                
                Picker("Day", selection: $selectedDay) {
                    ForEach(DayOption.allCases, id: \.self) { day in
                        Text(day.rawValue).tag(day)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                .background(cardBackgroundColor)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Activities Now")
                    .font(.headline)
                    .foregroundColor(textColor)
                    .padding(.bottom, 5)
                
                HStack {
                    ActivityButton(activity: "Cycling", condition: "Good", selectedActivity: $selectedActivity, textColor: textColor, cardBackgroundColor: cardBackgroundColor, highlightColor: highlightColor)
                    Spacer()
                    ActivityButton(activity: "Yoga", condition: "Warmer", selectedActivity: $selectedActivity, textColor: textColor, cardBackgroundColor: cardBackgroundColor, highlightColor: highlightColor)
                    Spacer()
                    ActivityButton(activity: "Basketball", condition: "Warmer", selectedActivity: $selectedActivity, textColor: textColor, cardBackgroundColor: cardBackgroundColor, highlightColor: highlightColor)
                }
                
                Text("This Afternoon")
                    .font(.headline)
                    .foregroundColor(textColor)
                    .padding(.bottom, 5)
                
                HStack {
                    ActivityButton(activity: "Swimming", condition: "Good", selectedActivity: $selectedActivity, textColor: textColor, cardBackgroundColor: cardBackgroundColor, highlightColor: highlightColor)
                    Spacer()
                    ActivityButton(activity: "Sprinting", condition: "Warmer", selectedActivity: $selectedActivity, textColor: textColor, cardBackgroundColor: cardBackgroundColor, highlightColor: highlightColor)
                    Spacer()
                    ActivityButton(activity: "Kayaking", condition: "Warmer", selectedActivity: $selectedActivity, textColor: textColor, cardBackgroundColor: cardBackgroundColor, highlightColor: highlightColor)
                }
                
                Text("This Evening")
                    .font(.headline)
                    .foregroundColor(textColor)
                    .padding(.bottom, 5)
                
                HStack {
                    ActivityButton(activity: "HIIT", condition: "Colder", selectedActivity: $selectedActivity, textColor: textColor, cardBackgroundColor: cardBackgroundColor, highlightColor: highlightColor)
                    Spacer()
                    ActivityButton(activity: "Jogging", condition: "Colder", selectedActivity: $selectedActivity, textColor: textColor, cardBackgroundColor: cardBackgroundColor, highlightColor: highlightColor)
                    Spacer()
                    ActivityButton(activity: "Soccer", condition: "Colder", selectedActivity: $selectedActivity, textColor: textColor, cardBackgroundColor: cardBackgroundColor, highlightColor: highlightColor)
                }
            }
            .padding(.horizontal)
            
            Button(action: addActivity) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Activity to Schedule")
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedActivity != nil ? highlightColor : Color.gray)
                .foregroundColor(backgroundColor)
                .cornerRadius(15)
                .padding(.horizontal)
            }
            .disabled(selectedActivity == nil)
            
            Spacer()
        }
        .padding(.vertical)
        .background(backgroundColor.ignoresSafeArea())
    }
    
    private func addActivity() {
        for activity in scheduledActivities.filter({ $0.day == selectedDay.rawValue }) {
            context.delete(activity)
        }
        
        if let activity = selectedActivity {
            let location = locations.randomElement() ?? "Unknown Location"
            let newActivity = ActivityRecord(activityName: activity, location: location, day: selectedDay.rawValue, time: "7 AM")
            
            context.insert(newActivity)
            
            selectedActivity = nil
        }
    }
    
    private func removeActivity(_ activity: ActivityRecord) {
        context.delete(activity)
    }
    
    private func getRandomWeatherData() -> (String, String, String, String) {
        let temperatures = ["18°C", "20°C", "22°C", "25°C", "28°C"]
        let winds = ["5 km/h", "10 km/h", "15 km/h", "20 km/h"]
        let humidities = ["40%", "50%", "60%", "70%"]
        let precipitations = ["0 mm", "2 mm", "5 mm", "8 mm"]
        
        return (
            temperatures.randomElement() ?? "20°C",
            winds.randomElement() ?? "9 km/h",
            humidities.randomElement() ?? "41%",
            precipitations.randomElement() ?? "0 mm"
        )
    }
}

struct WeatherDetailView: View {
    var icon: String
    var label: String
    var value: String
    var textColor: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(textColor)
            Text(label)
                .fontWeight(.bold)
                .foregroundColor(textColor)
            Text(value)
                .font(.caption)
                .foregroundColor(textColor.opacity(0.7))
        }
    }
}

struct ActivityButton: View {
    var activity: String
    var condition: String
    @Binding var selectedActivity: String?
    var textColor: Color
    var cardBackgroundColor: Color
    var highlightColor: Color
    
    var body: some View {
        VStack {
            Text(activity)
                .fontWeight(.bold)
            Text(condition)
                .font(.caption)
                .foregroundColor(textColor.opacity(0.7))
        }
        .padding()
        .frame(width: 110, height: 50)
        .background(selectedActivity == activity ? highlightColor : cardBackgroundColor)
        .cornerRadius(10)
        .foregroundColor(selectedActivity == activity ? Color(red: 43/255, green: 58/255, blue: 84/255) : textColor)
        .onTapGesture {
            if selectedActivity == activity {
                selectedActivity = nil
            } else {
                selectedActivity = activity
            }
        }
    }
}

// Preview
struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
            .modelContainer(for: ActivityRecord.self)
    }
}
