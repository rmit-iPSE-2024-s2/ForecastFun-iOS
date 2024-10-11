//
//  WeatherWidget.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 11/10/2024.
//

import Foundation
import WidgetKit
import SwiftUI
import CoreLocation
// WeatherEntry acts as the data model for the widget.
struct WeatherEntry: TimelineEntry {
    let date: Date // Date for when the conditions are for.
    let temperature: String // Temperature based on the above date.
    let weatherDescription: String // Description of current weather conditions.
    let activitySuggestion: String // An activity that would suit the current conditions.
    let circleColor: Color // Red / Green / Yellow based on temperature conditions.
}

struct WeatherProvider: TimelineProvider { // Fetches data for the widget and provides TimelineEntry.
    
    let weatherManagerWidget = WeatherManagerWidget() // Allows for weather fetching from the other file.
    // Placeholder provides a default static value before the widget completes loading.
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), temperature: "--", weatherDescription: "Loading...", activitySuggestion: "No suggestion", circleColor: .gray)
    }
    // For when a quick preview of the weather widget is needed.
    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        let entry = WeatherEntry(date: Date(), temperature: "--", weatherDescription: "Snapshot Weather", activitySuggestion: "No suggestion", circleColor: .gray)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        Task {
            let location = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) 
            // Fetches the current weather using WeatherManagerWidget file.
            do {
                let weatherData = try await weatherManagerWidget.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                
                let currentWeather = weatherData.current
                let temperature = String(format: "%.0f", currentWeather.temp)
                let weatherDescription = currentWeather.weather.first?.description ?? "No data"
                let tempValue = currentWeather.temp
                // This suggests an activity based on the temperature.
                let activitySuggestion = suggestActivity(for: tempValue)
                // This shows a corresponding colour based on the temperature.
                let circleColor = getCircleColor(for: tempValue)
                
                let entry = WeatherEntry(date: Date(), temperature: "\(temperature)°C", weatherDescription: weatherDescription, activitySuggestion: activitySuggestion, circleColor: circleColor)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 15)))
                completion(timeline)
                // Error message incase weather fetching fails.
            } catch {
                let entry = WeatherEntry(date: Date(), temperature: "--", weatherDescription: "Error fetching weather", activitySuggestion: "No suggestion", circleColor: .gray)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }
    // This suggests an activity based on the temperature as seen on line 45.
    private func suggestActivity(for temperature: Double) -> String {
        if temperature >= 20 {
            return "Walking, Running, Swimming"
        } else if temperature <= 10 {
            return "Basketball, Indoor Soccer"
        } else {
            return "Yoga, Gym"
        }
    }

    // This shows a corresponding colour based on the temperature as seen on line 47.
    private func getCircleColor(for temperature: Double) -> Color {
        if temperature >= 20 {
            return .green
        } else if temperature >= 15 {
            return .yellow
        } else {
            return .blue
        }
    }
}

struct WeatherWidgetEntryView: View {
    var entry: WeatherProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack {
            Text(entry.temperature)
            // Displays the temp in a large bold font.
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            // Displays the weather conditions.
            Text(entry.weatherDescription)
                .font(.caption)
                .foregroundColor(.white)
            Spacer()
            // Shows only the first activity in the array if its a small widget.
            if widgetFamily == .systemSmall {
               
                HStack {
                    Circle()
                        .fill(entry.circleColor)
                        .frame(width: 10, height: 10)
                    Text(firstSuggestedActivity(from: entry.activitySuggestion))
                        .font(.headline)
                        .foregroundColor(.white)
                }
                // If the widget is big, display all activities that are suitable.
            } else {
                
                HStack {
                    Circle()
                        .fill(entry.circleColor)
                        .frame(width: 10, height: 10)
                    Text(entry.activitySuggestion)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)
                }
            }
        }
        .padding()
        .background(Color("widgetBlue"))
        .containerBackground(.fill, for: .widget)
    }
    
    // Helper function to help return the first suggested activity
    private func firstSuggestedActivity(from suggestion: String) -> String {
        return suggestion.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? ""
    }
}

// Defines the main widget.
@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget" // Identifier for the widet.

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Current Weather")
        .description("Shows the current weather and temperature.")
        .supportedFamilies([.systemSmall, .systemMedium]) // Supported widget sizes.
    }
}

// Widget Preview
struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        // Preview for small widget.
        WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), temperature: "20°C", weatherDescription: "Sunny", activitySuggestion: "Walking, Running, Swimming", circleColor: .green))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        // Preview for medium widget.
        WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), temperature: "15°C", weatherDescription: "Cloudy", activitySuggestion: "Yoga, Gym", circleColor: .yellow))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        // Preview for medium widget with alternate weather.
        WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), temperature: "10°C", weatherDescription: "Raining", activitySuggestion: "Movies, Gaming", circleColor: .red))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
