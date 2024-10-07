//
//  ActivitiesNow.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 4/10/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct ActivityView: View {
    var activities: [Activity]
    var activity: Activity
    var weather: ResponseBody
    var weatherDate: Int
    
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
    

    private var conditionText: String {
        let activityColor = determineActivityColor(activity: activity, currentTemp: temp, currentPrecip: precip, currentHumidity: humidity, currentWind: wind)
        if activityColor == .green {
            return "Good Conditions"
        } else if activityColor == .yellow{
            return "Fair Conditions"
        } else {
            return "Poor Conditions"
        }
    }
    
    private var bgColor: Color {
        return determineActivityColor(activity: activity, currentTemp: temp, currentPrecip: precip, currentHumidity: humidity, currentWind: wind)
    }
    

    var body: some View {
        VStack {
            VStack(spacing: 5) {
                HStack {

                    Text(activity.activityName)
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
                        PreviewConditionView(activities: activities, activity: activity, weather: weather, weatherDate:weatherDate)
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
        
        return ActivityView(
            activities: [
                Activity(
                    activityId: 1,
                    activityName: "Running",
                    humidityRange: [40, 60],
                    temperatureRange: [15, 25],
                    windRange: [0, 10],
                    precipRange: [0, 1],
                    keyword: "outdoor",
                    added: true,
                    scheduled: false
                ),
                Activity(
                    activityId: 2,
                    activityName: "Cycling",
                    humidityRange: [30, 70],
                    temperatureRange: [10, 20],
                    windRange: [0, 15],
                    precipRange: [0, 2],
                    keyword: "outdoor",
                    added: true,
                    scheduled: false
                )
            ],
            activity:
                Activity(
                    activityId: 1,
                    activityName: "Running",
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
            weatherDate: 1727488800
        )
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
