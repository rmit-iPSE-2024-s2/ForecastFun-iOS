//
//  ActivitiesNow.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 4/10/2024.
//

import Foundation
import SwiftUI
import SwiftData
import CoreLocation

/// Small card that previews an added activity and its conditions for the current day - i.e. through color and condition statement (e.g. Poor conditions)
struct ActivityView: View {
    @Query var activities: [Activity]
    var activity: Activity
    var weather: ResponseBody
    var weatherDate: Int
    var location: CLLocationCoordinate2D
    
    @State private var showingPopover = false


    private var weatherDay: ResponseBody.DailyWeatherResponse? {
        return getWeatherForDate(date: weatherDate, data: weather)
    }
    
    private var temp: Double {
        return weatherDay?.temp.day ?? 0.0
    }

    private var wind: Double {
        return weatherDay?.wind_speed ?? 0.0
    }

    private var humidity: Int {
        return weatherDay?.humidity ?? 0
    }

    private var precip: Double {
        return weatherDay?.dailyPrecipitation ?? 0.0
    }
    

    private var conditionText: String{
        if let weatherDay = weatherDay{
            return determineConditionText(activity: activity, day: weatherDay )
        }
        return "No Conditions"
    }
    
    private var bgColor: Color {
        return determineActivityColor(activity: activity, currentTemp: temp, currentPrecip: precip, currentHumidity: humidity, currentWind: wind)
    }
    

    var body: some View {
        VStack {
            VStack(spacing: 5) {
                HStack {
                    Text("\(activity.activityName)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 22))
                    
                    Button(action: {
                        showingPopover = true
                    }) {
                        Image(systemName: "arrow.forward.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .popover(isPresented: $showingPopover) {
                        PreviewConditionView(showingPopover: $showingPopover,activity: activity, weather: weather, weatherDate:weatherDate, location: location)
                    }
                }
                .padding(.bottom, 8)
                .overlay(
                    Rectangle()
                        .frame(height: 3.5)
                        .cornerRadius(10)
                        .foregroundColor(bgColor),
                    alignment: .bottom
                )
                .foregroundColor(Color(red: 226/255, green: 237/255, blue: 255/255, opacity: 1.0))
                
                ZStack {
                    Text(conditionText)
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                    
                }
                .padding(.bottom, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cornerRadius(6)
            }
            .padding(12)
            .background(Color(red: 36/255, green: 50/255, blue: 71/255, opacity: 1))
            .cornerRadius(15)
            .frame(width: 230)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 226/255, green: 237/255, blue: 255/255, opacity: 0.2), lineWidth: 1)
            )
        }
    }
}


#Preview {
    do {
        let previewer = try ActivityPreviewer()
        @State var isPopoverPresented = true
        let mockLocation = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        return ActivityView(
            activity:
                Activity(
                    activityId: 1,
                    activityName: "Picnic",
                    humidityRange: [40, 60],
                    temperatureRange: [15, 25],
                    windRange: [0, 10],
                    precipRange: [0, 1],
                    keyword: "outdoor",
                    added: true,
                    scheduled: false
                )
                ,
            weather: previewWeather,
            weatherDate: 1727575200,
            location: mockLocation
        )
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
