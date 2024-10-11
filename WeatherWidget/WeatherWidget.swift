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

struct WeatherEntry: TimelineEntry {
    let date: Date
    let temperature: String
    let weatherDescription: String
    let activitySuggestion: String
    let circleColor: Color
}

struct WeatherProvider: TimelineProvider {
    
    let weatherManagerWidget = WeatherManagerWidget()

    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), temperature: "--", weatherDescription: "Loading...", activitySuggestion: "No suggestion", circleColor: .gray)
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        let entry = WeatherEntry(date: Date(), temperature: "--", weatherDescription: "Snapshot Weather", activitySuggestion: "No suggestion", circleColor: .gray)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        Task {
            let location = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) 
            
            do {
                let weatherData = try await weatherManagerWidget.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                
                let currentWeather = weatherData.current
                let temperature = String(format: "%.0f", currentWeather.temp)
                let weatherDescription = currentWeather.weather.first?.description ?? "No data"
                let tempValue = currentWeather.temp
                
                let activitySuggestion = suggestActivity(for: tempValue)
                let circleColor = getCircleColor(for: tempValue)
                
                let entry = WeatherEntry(date: Date(), temperature: "\(temperature)°C", weatherDescription: weatherDescription, activitySuggestion: activitySuggestion, circleColor: circleColor)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 15)))
                completion(timeline)
                
            } catch {
                let entry = WeatherEntry(date: Date(), temperature: "--", weatherDescription: "Error fetching weather", activitySuggestion: "No suggestion", circleColor: .gray)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }

    private func suggestActivity(for temperature: Double) -> String {
        if temperature >= 20 {
            return "Walking, Running, Swimming"
        } else if temperature <= 10 {
            return "Basketball, Indoor Soccer"
        } else {
            return "Yoga, Gym"
        }
    }

   
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
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            Text(entry.weatherDescription)
                .font(.caption)
                .foregroundColor(.white)
            Spacer()

            if widgetFamily == .systemSmall {
               
                HStack {
                    Circle()
                        .fill(entry.circleColor)
                        .frame(width: 10, height: 10)
                    Text(firstSuggestedActivity(from: entry.activitySuggestion))
                        .font(.headline)
                        .foregroundColor(.white)
                }
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
    

    private func firstSuggestedActivity(from suggestion: String) -> String {
        return suggestion.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? ""
    }
}

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Current Weather")
        .description("Shows the current weather and temperature.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// Widget Preview
struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), temperature: "20°C", weatherDescription: "Sunny", activitySuggestion: "Walking, Running, Swimming", circleColor: .green))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), temperature: "15°C", weatherDescription: "Cloudy", activitySuggestion: "Yoga, Gym", circleColor: .yellow))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), temperature: "10°C", weatherDescription: "Raining", activitySuggestion: "Movies, Gaming", circleColor: .red))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
