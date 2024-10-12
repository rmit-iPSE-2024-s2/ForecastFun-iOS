//
//  AddToScheduleView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 5/10/2024.
//

import SwiftUI
import SwiftData
import Foundation
import CoreLocation

/// View that previews the conditions for a filtered activity and day
struct PreviewConditionView: View {
    @Binding var showingPopover: Bool
    @Query var activities: [Activity]
    var activity: Activity
    var weather: ResponseBody
    var weatherDate: Int
    var location: CLLocationCoordinate2D
    
    @State private var selectedActivityIndex: Int = 0
    @State private var selectedDayIndex: Int = 0
    
    private var originalActivityIndex: Int { selectedActivityIndex }
    private var originalDayIndex: Int { selectedDayIndex }
    
    // define a list with upcoming days
    private var dayForecasts: [ResponseBody.DailyWeatherResponse] {
        Array(weather.daily.prefix(4))
    }
    
    // define the selected activity
    var selectedActivity: Activity? {
        // make guard against empty activities
        guard !activities.filter({ $0.added }).isEmpty else { return nil }
        return activities.filter { $0.added }.indices.contains(selectedActivityIndex) ? activities.filter { $0.added }[selectedActivityIndex] : nil
    }
    
    var selectedDay: ResponseBody.DailyWeatherResponse {
        dayForecasts[selectedDayIndex]
    }
    
    init(showingPopover: Binding<Bool>, activity: Activity, weather: ResponseBody, weatherDate: Int, location: CLLocationCoordinate2D) {
        self._showingPopover = showingPopover
        self.activity = activity
        self.weather = weather
        self.weatherDate = weatherDate
        self.location = location
    }
    
    private var conditionText: String {
        guard let activity = selectedActivity else {
            return "Activity not found" // Handle the case when there's no selected activity
        }
        
        let activityColor = determineActivityColor(
            activity: activity,
            currentTemp: dayForecasts[selectedDayIndex].temp.day,
            currentPrecip: dayForecasts[selectedDayIndex].dailyPrecipitation,
            currentHumidity: dayForecasts[selectedDayIndex].humidity,
            currentWind: dayForecasts[selectedDayIndex].wind_speed)
        
        if activityColor == .green {
            return "Good Conditions"
        } else if activityColor == .yellow {
            return "Fair Conditions"
        } else {
            return "Poor Conditions"
        }
    }
    
    
    private var isInRange: Bool {
        // Check if all conditions are within the range
        let inTempRange = activity.temperatureRange.contains(dayForecasts[selectedDayIndex].temp.day)
        let inHumidityRange = activity.humidityRange.contains(dayForecasts[selectedDayIndex].humidity)
        let inWindRange = activity.windRange.contains(dayForecasts[selectedDayIndex].wind_speed)
        let inPrecipRange = activity.precipRange.contains(dayForecasts[selectedDayIndex].dailyPrecipitation)
        
        // Return true if all conditions are in range
        return [inTempRange, inHumidityRange, inWindRange, inPrecipRange].allSatisfy { $0 }
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(red: 43/255, green:58/255 , blue: 84/255, opacity: 1.0)
                    .ignoresSafeArea(.all)
                VStack(spacing:20) {
                    HStack{
                        Text("\(selectedActivity?.activityName ?? "Select an Activity")")
                            .font(.system(size:28))
                            .padding(.top, 40)
                            .frame(alignment: .leading)
                        
                        Spacer()
                        
                        ZStack {
                            Picker("Select an Activity", selection: $selectedActivityIndex) {
                                ForEach(0..<activities.filter { $0.added }.count, id: \.self) { index in
                                    Text(activities.filter { $0.added }[index].activityName)
                                        .tint(.white)
                                        .tag(index)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .background(Color(red: 36/255, green: 50/255, blue: 71/255, opacity: 1))
                            .cornerRadius(10)
                        }
                        .offset(y: 22)
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Rectangle()
                        .frame(width: 348, height: 1)
                        .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                        .opacity(0.7)
                    
                    
                    Picker("Select a Day", selection: $selectedDayIndex) {
                        ForEach(0..<dayForecasts.count, id: \.self) { index in
                            Text("\(dayForecasts[index].dt.convertToDayOfWeek())")
                                .tag(index)
                                .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onAppear {
                        // Set UISegmentedControl appearance when the view appears
                        UISegmentedControl.appearance().backgroundColor = .clear
                        UISegmentedControl.appearance().tintColor = .white
                        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 36/255, green: 50/255, blue: 71/255, alpha: 1.0)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                    }
                    
                    // Preview for temperature and precipitation
                    HStack(spacing:20){
                        
                        VStack(spacing:20){
                            HStack{
                                
                                VStack(alignment: .leading){
                                    Text("Temperature °C")
                                        .font(.system(size:17))
                                        .padding(.bottom, 0.5)
                                    HStack{
                                        Image(systemName :"thermometer")
                                            .font(.system(size:18))
                                        
                                        Text("\(dayForecasts[selectedDayIndex].temp.day.roundDouble())")
                                            .font(.system(size:25))
                                            .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                                    }
                                    .padding(.bottom,-1)
                                    Rectangle()
                                        .frame(height: 3)
                                        .foregroundColor(determineInRange(conditionRange: selectedActivity?.temperatureRange ?? [0,0], currentCondition: dayForecasts[selectedDayIndex].temp.day)) // dynamic color that changes based on whether it is within range
                                        .opacity(0.7)
                                    
                                    Text("Ideal: \(selectedActivity?.temperatureRange.first?.roundDouble() ?? "") - \(selectedActivity?.temperatureRange.last?.roundDouble() ?? "") °C")
                                        .font(.system(size:15))
                                    
                                }
                                .frame(width: 130)
                                
                                Spacer()
                                
                                VStack(alignment: .leading){
                                    Text("Precipitation mm")
                                        .font(.system(size:17))
                                        .padding(.bottom, 0.5)
                                    HStack{
                                        Image(systemName :"drop")
                                            .font(.system(size:18))
                                        
                                        Text("\(String(format: "%.1f", dayForecasts[selectedDayIndex].dailyPrecipitation))")
                                            .font(.system(size:25))
                                            .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                                    }
                                    .padding(.bottom,-1)
                                    Rectangle()
                                        .frame(height: 3)
                                        .foregroundColor(determineInRange(conditionRange: selectedActivity?.precipRange ?? [0,0], currentCondition: dayForecasts[selectedDayIndex].dailyPrecipitation))
                                        .opacity(0.7)
                                    
                                    Text("Ideal: \(selectedActivity?.precipRange.first?.roundDouble() ?? "") - \(selectedActivity?.precipRange.last?.roundDouble() ?? "") mm")
                                        .font(.system(size:15))
                                    
                                }
                                .frame(width: 130)
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top, .horizontal],12)
                            
                            
                            Rectangle()
                                .frame(width: 323, height: 1)
                                .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                                .opacity(0.7)
                            
                            // Preview for humidity and wind
                            VStack(spacing:20){
                                HStack{
                                    
                                    VStack(alignment: .leading){
                                        Text("Humidity %")
                                            .font(.system(size:17))
                                            .padding(.bottom, 0.5)
                                        HStack{
                                            Image(systemName :"humidity")
                                                .font(.system(size:18))
                                            
                                            Text("\(dayForecasts[selectedDayIndex].humidity)")
                                                .font(.system(size:25))
                                                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                                        }
                                        .padding(.bottom,-1)
                                        Rectangle()
                                            .frame(height: 3)
                                            .foregroundColor(determineInRange(
                                                conditionRange: selectedActivity?.humidityRange.map { Double($0) } ?? [0.0, 0.0],
                                                currentCondition: Double(dayForecasts[selectedDayIndex].humidity)
                                            ))
                                            .opacity(0.7)
                                        Text("Ideal: \(selectedActivity?.humidityRange.first ?? 0) - \(selectedActivity?.humidityRange.last ?? 0) %")
                                            .font(.system(size:15))
                                        
                                    }
                                    .frame(width: 130)
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading){
                                        Text("Wind km/h")
                                            .font(.system(size:17))
                                            .padding(.bottom, 0.5)
                                        HStack{
                                            Image(systemName :"wind")
                                                .font(.system(size:18))
                                            
                                            Text("\(dayForecasts[selectedDayIndex].wind_speed.roundDouble())")
                                                .font(.system(size:25))
                                                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                                        }
                                        .padding(.bottom,-1)
                                        Rectangle()
                                            .frame(height: 3)
                                            .foregroundColor(determineInRange(conditionRange: selectedActivity?.windRange ?? [0,0], currentCondition: dayForecasts[selectedDayIndex].wind_speed))
                                            .opacity(0.7)
                                        
                                        Text("Ideal: \(selectedActivity?.windRange.first?.roundDouble() ?? "") - \(selectedActivity?.windRange.last?.roundDouble() ?? "") km/h")
                                            .font(.system(size:15))
                                        
                                    }
                                    .frame(width: 130)
                                    
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                
                                Rectangle()
                                    .frame(width: 323, height: 1)
                                    .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                                    .opacity(0.7)
                                
                                Text("\(conditionText) for this activity on \(dayForecasts[selectedDayIndex].dt.convertToFullDayOfWeek())")
                                    .padding(.bottom, 10)
                                    .frame(width: 320,height: 55)
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            }
                        }
                        .padding(15)
                        
                    }
                    .frame(width: 360)
                    .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1)
                    )
                    
                    
                    Text("Would you like to add this activity to your schedule")
                        .frame(height: 55)
                    
                    
                    
                    HStack{
                        
                        HStack{
                            Image(systemName :"calendar")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Finalise your Activity")
                                .fontWeight(.bold)
                                .padding(.horizontal, 15)
                                .font(.system(size:17.5))
                                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                            
                            
                            if let activity = selectedActivity {
                                NavigationLink(destination: NewScheduleView(showingPopover:$showingPopover, selectedActivity: activity, selectedDay: dayForecasts[selectedDayIndex], location: location)) {
                                    Image(systemName: "arrow.forward.circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color(red: 226/255, green: 237/255, blue: 255/255, opacity: 1.0))
                                }
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
                            .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1))
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(30)
            .onAppear {
                if let index = activities.filter({ $0.added }).firstIndex(where: { $0.activityId == activity.activityId }) {
                    selectedActivityIndex = index
                } else {
                    selectedActivityIndex = 0
                }
                
                // Find the day index in dayForecasts
                if let firstForecastDate = dayForecasts.first?.dt,
                   let lastForecastDate = dayForecasts.last?.dt {
                    if let dayIndex = dayForecasts.firstIndex(where: { $0.dt == weatherDate }) {
                        selectedDayIndex = dayIndex
                    } else {
                        selectedDayIndex = 0
                    }
                }
            }
            .onDisappear {
                selectedActivityIndex = originalActivityIndex
            }
            
            
        }
        .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
    }
}




#Preview {
    do {
        let previewer = try ActivityPreviewer()
        @State var showingPopover = true
        let mockLocation = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        
        return PreviewConditionView(
            showingPopover: $showingPopover,
            activity:
                Activity(
                    activityId: 8,
                    activityName: "Picnic",
                    humidityRange: [40, 60],
                    temperatureRange: [18.0, 26.0],
                    windRange: [0.0, 5.0],
                    precipRange: [0.0, 0.05],
                    keyword: "park",
                    added: true,
                    scheduled: false
                ),
            weather: previewWeather,
            weatherDate: 1727575200,
            location: mockLocation
        )
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

