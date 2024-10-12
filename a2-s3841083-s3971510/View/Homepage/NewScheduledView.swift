//
//  NewScheduleView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 8/10/2024.
//

import SwiftUI
import CoreLocation

struct NewScheduleView: View {
    @Binding var showingPopover: Bool
    @State private var addedActivity: Bool = false
    @State private var toggleConfirm: Bool = false
    var selectedActivity: Activity
    var selectedDay: ResponseBody.DailyWeatherResponse
    @Environment(\.modelContext) private var context
    
    var location: CLLocationCoordinate2D
    
    @State var selectedLocation: String? = ""
    
    private var conditionText: String{
        return determineConditionText(activity: selectedActivity, day: selectedDay)
    }
    
    var body: some View {
        VStack{
            ZStack{
                Color(red: 43/255, green:58/255 , blue: 84/255, opacity: 1.0)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 15){
                    
                    // Title
                    VStack(alignment:.leading){
                        Text("Add To Schedule")
                            .font(.system(size:28))
                            .padding(.top, 40)
                            .frame(alignment: .leading)
                        
                        Rectangle()
                            .frame(width: 348, height: 1)
                            .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                            .opacity(0.7)
                    }
                    .padding(.horizontal, 15)
                    
                    HStack(spacing:20){
                        
                        VStack(spacing:20){
                            
                            
                            
                            // Added activity
                            HStack{
                                Text("\(selectedActivity.activityName) for \(selectedDay.dt.convertToFullDayOfWeek())")
                                    .font(.system(size: 23))
                                    .padding(.leading, 10)
                                
                                Spacer()
                                
                            }
                            .padding(.top,15)
                            HStack{
                                
                                VStack(alignment: .leading){
                                    Text("Temperature °C")
                                        .font(.system(size:17))
                                        .padding(.bottom, 0.5)
                                    HStack{
                                        Image(systemName :"thermometer")
                                            .font(.system(size:18))
                                        
                                        Text("\(selectedDay.temp.day.roundDouble())")
                                            .font(.system(size:25))
                                            .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                                    }
                                    .padding(.bottom,-1)
                                    Rectangle()
                                        .frame(height: 3)
                                        .foregroundColor(determineInRange(conditionRange: selectedActivity.temperatureRange, currentCondition: selectedDay.temp.day))
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
                                        
                                        Text("\(selectedDay.dailyPrecipitation.roundDouble())")
                                            .font(.system(size:25))
                                            .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                                    }
                                    .padding(.bottom,-1)
                                    Rectangle()
                                        .frame(height: 3)
                                        .foregroundColor(determineInRange(conditionRange: selectedActivity.precipRange, currentCondition: selectedDay.dailyPrecipitation))
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
                                            
                                            Text("\(selectedDay.humidity)")
                                                .font(.system(size:25))
                                                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                                        }
                                        .padding(.bottom,-1)
                                        Rectangle()
                                            .frame(height: 3)
                                            .foregroundColor(determineInRange(conditionRange: selectedActivity.humidityRange.map { Double($0) }, currentCondition: Double(selectedDay.humidity)))
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
                                            
                                            Text("\(selectedDay.wind_speed.roundDouble())")
                                                .font(.system(size:25))
                                                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                                        }
                                        .padding(.bottom,-1)
                                        Rectangle()
                                            .frame(height: 3)
                                            .foregroundColor(determineInRange(conditionRange: selectedActivity.windRange, currentCondition: selectedDay.wind_speed))
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
                                
                                Text("\(conditionText) for this activity on \(selectedDay.dt.convertToFullDayOfWeek())")
                                    .padding(.bottom, 10)
                                    .frame(height: 55)
                            }
                        }
                        .padding(15)
                        
                        
                    }
                    .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                    .frame(width: 360)
                    .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1)
                    )
                    
                    // Location
                    HStack{
                        
                        HStack(spacing: 15){
                            Image(systemName :"map")
                                .font(.system(size:40))
                                .fontWeight(.thin)
                            
                            if selectedLocation == "" {
                                Text("No Location Added")
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 15)
                                    .font(.system(size:17.5))
                                    .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                            }
                            else{
                                if let selectedLocation = selectedLocation{
                                    Text("@ \(selectedLocation)")
                                        .frame(maxWidth: .infinity, alignment:.leading)
                                }
                            }

                            
                            NavigationLink(destination: DiscoveryView(location: location, selectedLocation:$selectedLocation)) {
                                Image(systemName: "plus.square")
                                    .font(.system(size:26))
                                    .fontWeight(.light)
                                    .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                            }
                            
                        }
                        .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
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
                    
                    // Add Button
                    
                    Button(action: {
                        addedActivity = true
                        showingPopover = false
                        withAnimation {
                            toggleConfirm.toggle()
                        }
                        
                        // Create a new ScheduledActivity instance
                        let newScheduledActivity = Activity(activityId: Int.random(in: 1000...9999), activityName: selectedActivity.activityName, humidityRange: selectedActivity.humidityRange, temperatureRange: selectedActivity.temperatureRange, windRange: selectedActivity.windRange, precipRange: selectedActivity.precipRange, keyword: selectedActivity.keyword, added: false, scheduled: true, start: selectedDay.dt, location: selectedLocation, conditionText: conditionText)
                        
                        
                        // Save to SwiftData context
                        context.insert(newScheduledActivity)
                        
                        do {
                            try context.save()
                            print("Activity saved successfully")
                        } catch {
                            print("Failed to save activity: \(error)")
                        }
                        
                    }) {
                        Text(!addedActivity ? "Add Activity" : "Added")
                            .font(.system(size: 20))
                            .frame(width: 170, height: 50)
                            .background(!addedActivity ? Color(red:36/255, green:50/255, blue: 71/255, opacity: 1) : Color(red:36/255, green:50/255, blue: 71/255, opacity: 0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1)
                            )
                    }
                    .disabled(addedActivity)
                    Spacer()
                        .frame(height:35)
                }
                .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                
                
            }
        }
    }
}


#Preview {
    do {
        let previewer = try ActivityPreviewer()
        @State var showingPopover = true
        let mockLocation = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        return NewScheduleView(
            showingPopover: $showingPopover,
            selectedActivity: Activity(
                activityId: 8,
                activityName: "Picnic",
                humidityRange: [40, 60],
                temperatureRange: [18.0, 26.0],
                windRange: [0.0, 5.0],
                precipRange: [0.0, 0.05],
                keyword: "park",
                added: false,
                scheduled: false
            ),
            selectedDay: ResponseBody.DailyWeatherResponse(
                dt: 1696204800, // Sample Unix timestamp for the date
                sunrise: 1696233600,
                sunset: 1696281600,
                moonrise: 1696245600,
                moonset: 1696274400,
                moon_phase: 0.5,
                summary: "Clear skies",
                temp: ResponseBody.TempResponse(day: 22.0, min: 18.0, max: 26.0, night: 16.0, eve: 21.0, morn: 18.5),
                feels_like: ResponseBody.FeelsLikeResponse(day: 22.5, night: 16.5, eve: 21.5, morn: 19.0),
                pressure: 1012,
                humidity: 55,
                dew_point: 10.5,
                wind_speed: 3.5,
                wind_deg: 270,
                wind_gust: 4.5,
                weather: [ResponseBody.WeatherResponse(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
                clouds: 0,
                pop: 0.0,
                rain: nil,
                uvi: 6.5
            ),
            location: mockLocation
        )
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
