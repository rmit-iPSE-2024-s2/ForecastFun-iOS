//
//  ScheduleView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 9/10/2024.
//

import SwiftUI
import SwiftData
import CoreLocation

struct ScheduleView: View {
    @Query var activities: [Activity]
    var weather: ResponseBody
    var location: CLLocationCoordinate2D
    @State var showInfoAlert: Bool = false
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedDayIndex: Int = 0
    
    private var dayForecasts: [ResponseBody.DailyWeatherResponse] {
        Array(weather.daily.prefix(4))
    }
    private var firstDailyDt: Int {
        return weather.daily.first?.dt ?? 0
    }
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea(.all)
            
            VStack {
                HStack{
                    Text("Scheduled Activities")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 30))
                        .padding(.top, 40)
                    
                    Button(action: {
                       showInfoAlert = true
                    }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 22))
                            .foregroundColor(textColor)
                    }
                    .alert(isPresented: $showInfoAlert) {
                        Alert(title: Text("Viewing Scheduled Activities"),
                              message: Text("To have a full view of your activities, long press to select a schedule and swipe down to reveal its info."),
                              dismissButton: .default(Text("Got it!")))
                    }
                    .padding(.top, 43)
                }
                .padding(.horizontal, 6)
                Picker("Select a Day", selection: $selectedDayIndex) {
                    ForEach(0..<dayForecasts.count, id: \.self) { index in
                        Text("\(dayForecasts[index].dt.convertToDayOfWeek())")
                            .tag(index)
                            .textCase(.uppercase)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onAppear {
                    // Customize the UISegmentedControl appearance
                    UISegmentedControl.appearance().backgroundColor = .clear
                    UISegmentedControl.appearance().tintColor = .white
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 36/255, green: 50/255, blue: 71/255, alpha: 1.0)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                }
                
                
                // define selected day for day index
                let selectedDay = dayForecasts[selectedDayIndex].dt
                
                let filteredActivities = activities.filter { $0.scheduled && $0.start == selectedDay }
                ScrollView{
                    VStack{
                        if filteredActivities.isEmpty { // if scheduled activities are empty for selected day

                            Text("You have no scheduled activities for \(selectedDay.convertToFullDayOfWeek())")
                                .multilineTextAlignment(.center)
                                .padding(.top, 150)
                                .frame(width: 250)
                                
                        } else {
                            
                            ForEach(filteredActivities, id: \.activityId) { activity in // if scheduled activities are present for selected day
                                let locationText = (activity.location?.isEmpty == false ? activity.location : "TBD") ?? "TBD"
                                let conditionText = activity.conditionText ?? "No Conditions"
                                let scheduledDay = activity.start ?? 0
                                
                                ExpandableView(thumbnail:
                                ThumbnailView(content:{
                                    
                                    
                                    ThumbnailViewContent(activityName: activity.activityName, scheduledDay: scheduledDay, locationText: locationText, conditionText: conditionText)
                                })
                                , expanded:
                                ExpandedView(content:{
                                    ExpandedViewContent(activity: activity, dayForecast: dayForecasts[selectedDayIndex])
                                })
                                )
                                
                                
                            }
                            
                            
                            
                            
                        }

                    }
                    .padding(.vertical, 20)
                }
                Spacer()
                if let activity = activities.first {
                    Rectangle()
                        .frame(width: 348, height: 1)
                        .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                        .opacity(0.7)
                        .padding(.bottom, 10)
                    
                    
                    newSchedCardView(activity: activity, weather: weather, weatherDate: firstDailyDt, location: location)
                        .padding(.bottom,11)
                }
            }
            .padding()
            .foregroundColor(textColor)
        }
        
    }
    
    func deleteActivity(activity: Activity) {
            modelContext.delete(activity) // Remove the activity from the context
            try? modelContext.save() // Save the context to persist the changes
    }
}

#Preview {
    do {
        let previewer = try ActivityPreviewer()
        let mockLocation = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        
        return ScheduleView(weather: previewWeather, location: mockLocation)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}



struct newSchedCardView : View{
    @Query var activities: [Activity]
    var activity: Activity
    var weather: ResponseBody
    var weatherDate: Int
    var location: CLLocationCoordinate2D
    
    @State private var showAlert = false
    @State private var showingPopover = false
    
    var body: some View{
        VStack{
            // Add new scheduled activity
            HStack{
                HStack{
                    
                    Image(systemName :"calendar")
                        .resizable()
                        .frame(width: 40, height: 40)

                    Text("New Scheduled Activity")
                        .fontWeight(.bold)
                        .padding(.horizontal, 15)
                        .font(.system(size:17.5))
                        .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                    
                    Button(action: {
                        
                        if activities.filter({ $0.added }).isEmpty {
                            showAlert = true
                        } else {
                            showingPopover = true
                        }
                    }) {
                        Image(systemName: "arrow.forward.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .popover(isPresented: $showingPopover) {
                        PreviewConditionView(showingPopover: $showingPopover, activity: activity, weather: weather, weatherDate:weatherDate, location: location)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                
            }
            .frame(width: 360)
            .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1)
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("No Liked Activities"),
                    message: Text("You don't have any liked activities to schedule an activity"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        
        
    }
}

struct scheduleCardView : View{
    @Query var activities: [Activity]
    var activity: Activity
    var weather: ResponseBody
    var weatherDate: Int
    
    var body: some View{
        VStack{
            
            let locationText = (activity.location?.isEmpty == false ? activity.location : "TBD") ?? "TBD"
            let scheduledDay = activity.start?.convertToDayOfWeek() ?? "..."
            let conditionText = activity.conditionText ?? "No Conditions"
            HStack{
                VStack(spacing:2){
                    Text("DAY")
                        .fontWeight(.bold)
                    Text("\(scheduledDay)")
                        .textCase(.uppercase)
                }
                .font(.system(size:23))
                .padding(15)
                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                
                VStack(spacing:13){
                    Text("\(activity.activityName) @ \(locationText)")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size:17.5))
                    HStack{
                        Text("\(conditionText)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            .font(.system(size:17))
                            .fontWeight(.semibold)
                            .padding(.bottom,1)
                    }
                    .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.7))
                    
                }
                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                
            }
            .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
            .cornerRadius(15)
            .frame(width: 360)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1)
            )
        
            
        }
        
        
    }
}

struct ThumbnailViewContent: View {
    var activityName: String
    var scheduledDay: Int
    var locationText: String
    var conditionText: String

    var body: some View {
        HStack {
            VStack(spacing: 2) {
                Text("DAY")
                    .fontWeight(.bold)
                Text("\(scheduledDay.convertToDayOfWeek())")
                    .textCase(.uppercase)
                    .fontWeight(.light)
            }
            .padding()
            .font(.system(size: 24))

            VStack(spacing: 10) {
                Text("\(activityName) @ \(locationText)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(conditionText)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical)
        }
    }
}

struct ExpandedViewContent: View {
    var activity: Activity
    var dayForecast: ResponseBody.DailyWeatherResponse
    @Environment(\.modelContext) private var modelContext
    @State var showDeleteAlert: Bool = false
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text("\(activity.activityName)")
                    .font(.system(size: 25))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(activity.start?.convertToFullDayOfWeek() ?? "") @ \(activity.location ?? "TBD")")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Rectangle()
                .frame(width: 338, height: 1)
                .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))

            VStack(spacing: 20) {
                HStack(spacing:28){
                    WeatherConditionView(
                        label: "Temperature °C",
                        systemImageName: "thermometer",
                        currentCondition: dayForecast.temp.day,
                        idealRange: activity.temperatureRange,
                        unit: "°C"
                    )
                    
                    WeatherConditionView(
                        label: "Precipitation mm",
                        systemImageName: "drop",
                        currentCondition: dayForecast.dailyPrecipitation,
                        idealRange: activity.precipRange,
                        unit: "mm"
                    )
                }
                
                HStack(spacing:28){
                    WeatherConditionView(
                        label: "Humidity %",
                        systemImageName: "humidity",
                        currentCondition: Double(dayForecast.humidity),
                        idealRange: activity.humidityRange.map { Double($0) },
                        unit: "%"
                    )
                    
                    WeatherConditionView(
                        label: "Wind km/h",
                        systemImageName: "wind",
                        currentCondition: dayForecast.wind_speed,
                        idealRange: activity.windRange,
                        unit: "km/h"
                    )
                }
            }
            .padding(.horizontal)

            Button(action: {
                showDeleteAlert = true // Show the delete alert
            }) {
                Text("Remove")
            }
            .padding(10)
            .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.4), lineWidth: 1)
            )
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Activity"),
                    message: Text("Are you sure you want to delete this activity?"),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteActivity(activity:activity)
                    },
                    secondaryButton: .cancel()
                    
                )
            }
        }
        .padding()
    }
    
    func deleteActivity(activity: Activity) {
            modelContext.delete(activity) // Remove the activity from the context
            try? modelContext.save() // Save the context to persist the changes
    }
}

struct WeatherConditionView: View {
    var label: String
    var systemImageName: String
    var currentCondition: Double
    var idealRange: [Double]
    var unit: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.system(size: 17))
                .padding(.bottom, 0.5)
            
            HStack {
                Image(systemName: systemImageName)
                    .font(.system(size: 18))
                
                Text("\(currentCondition.roundDouble())")
                    .font(.system(size: 25))
                    .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255, opacity: 1.0))
            }
            .padding(.bottom, -1)
            
            Rectangle()
                .frame(height: 3)
                .foregroundColor(determineInRange(conditionRange: idealRange, currentCondition: currentCondition))
                .opacity(0.7)
            
            Text("Ideal: \(idealRange.first?.roundDouble() ?? "") - \(idealRange.last?.roundDouble() ?? "") \(unit)")
                .font(.system(size: 15))
        }
        .frame(width: 130)
    }
}

