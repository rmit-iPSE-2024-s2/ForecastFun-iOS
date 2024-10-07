//
//  AddToScheduleView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 5/10/2024.
//

import SwiftUI
import Foundation

struct PreviewConditionView: View {
    var activities: [Activity]
    var activity: Activity
    var weather: ResponseBody
    var weatherDate: Int
    
    @State private var selectedActivityIndex: Int
    @State private var selectedDayIndex: Int
    private let originalActivityIndex: Int
    private let originalDayIndex: Int
    
    private var dayForecasts: [ResponseBody.DailyWeatherResponse] {
            Array(weather.daily.prefix(4)) // Extract the first 4 days from the weather response
    }
    
    init(activities: [Activity], activity: Activity, weather: ResponseBody, weatherDate: Int) {
        self.activities = activities
        self.activity = activity
        self.weather = weather
        self.weatherDate = weatherDate
        
        var dayForecasts: [ResponseBody.DailyWeatherResponse] {
            // Extract the first 4 days from the weather response
            Array(weather.daily.prefix(4)) // This returns an array of 4 daily forecasts
        }
        
        // Set initial selected activity index
        if let index = activities.firstIndex(where: { $0.activityId == activity.activityId }) {
            _selectedActivityIndex = State(initialValue: index)
            originalActivityIndex = index
        } else {
            _selectedActivityIndex = State(initialValue: 0)
            originalActivityIndex = 0
        }
        
        // Set initial selected day index
        if let dayIndex = dayForecasts.firstIndex(where: { $0.dt == weatherDate }) {
            _selectedDayIndex = State(initialValue: dayIndex) // Correct variable name
            originalDayIndex = dayIndex
        } else {
            _selectedDayIndex = State(initialValue: 0) // Correct variable name
            originalDayIndex = 0
        }
    }
        
    // Computed property to get the selected activity
    var selectedActivity: Activity {
        activities[selectedActivityIndex]
    }
    
    var selectedDay: ResponseBody.DailyWeatherResponse {
        dayForecasts[selectedDayIndex]
    }
    
//    \(dayForecasts[selectedDayIndex].temp.day.roundDouble())
    
    private var conditionText: String {
        let activityColor = determineActivityColor(activity: selectedActivity, currentTemp: dayForecasts[selectedDayIndex].temp.day, currentPrecip: dayForecasts[selectedDayIndex].dailyPrecipitation, currentHumidity: dayForecasts[selectedDayIndex].humidity, currentWind: dayForecasts[selectedDayIndex].wind_speed)
        
        if activityColor == .green {
            return "Good Conditions"
        } else if activityColor == .yellow{
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
                    Text("\(selectedActivity.activityName)")
                        .font(.system(size:28))
                        .padding(.top, 40)
                        .frame(alignment: .leading)
                        
                        Spacer()
                        
                        ZStack {
                            Picker("Select an Activity", selection: $selectedActivityIndex) {
                                ForEach(0..<activities.count, id: \.self) { index in
                                    Text(activities[index].activityName)
                                        .tint(.white)
                                        .tag(index)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            // Apply background color and corner radius to the ZStack
                            .background(Color(red: 36/255, green: 50/255, blue: 71/255, opacity: 1))
                            .cornerRadius(10) // Apply corner radius
                        }
                        .offset(y: 22)
                               
                    }
                    .padding(.horizontal, 20)
                    
                    Rectangle()
                        .frame(width: 348, height: 1)
                        .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                        .opacity(0.7)
                    
//                    DayPickerView(selectedSegment: $selectedDayIndex, dayForecasts: dayForecasts)
                    
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
                                        .foregroundColor(determineInRange(conditionRange: selectedActivity.temperatureRange, currentCondition: dayForecasts[selectedDayIndex].temp.day)) // dynamic color that changes based on whether it is within range
                                        .opacity(0.7)

                                    Text("Ideal: \(selectedActivity.temperatureRange.first?.roundDouble() ?? "") - \(selectedActivity.temperatureRange.last?.roundDouble() ?? "") °C")
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
                                        .foregroundColor(determineInRange(conditionRange: selectedActivity.precipRange, currentCondition: dayForecasts[selectedDayIndex].dailyPrecipitation))
                                        .opacity(0.7)
                                    
                                    Text("Ideal: \(selectedActivity.precipRange.first?.roundDouble() ?? "") - \(selectedActivity.precipRange.last?.roundDouble() ?? "") mm")
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
                                            .foregroundColor(determineInRange(conditionRange: selectedActivity.humidityRange.map { Double($0) }, currentCondition: Double(dayForecasts[selectedDayIndex].humidity)))
                                            .opacity(0.7)
                                        Text("Ideal: \(selectedActivity.humidityRange.first ?? 0) - \(selectedActivity.humidityRange.last ?? 0) %")
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
                                            .foregroundColor(determineInRange(conditionRange: selectedActivity.windRange, currentCondition: dayForecasts[selectedDayIndex].wind_speed))
                                            .opacity(0.7)
                                        
                                        Text("Ideal: \(selectedActivity.windRange.first?.roundDouble() ?? "") - \(selectedActivity.windRange.last?.roundDouble() ?? "") km/h")
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
                                
                                Text("\(conditionText) for this activity on \(dayForecasts[selectedDayIndex].dt.convertToDayOfWeek())")
                                    .padding(.bottom, 10)
                                    .frame(height: 55)
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
                            
                            Text("New Scheduled Activity")
                                .fontWeight(.bold)
                                .padding(.horizontal, 15)
                                .font(.system(size:17.5))
                                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                            
                            Image(systemName :"arrow.forward.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                            
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
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .onDisappear {
                    selectedActivityIndex = originalActivityIndex
                }
                
                
            }
            .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
        }
    }
}


#Preview {
    // Mock data for multiple activities
    PreviewConditionView(
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
                precipRange: [0, 0],
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
}
