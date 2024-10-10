//
//  ScheduleView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 9/10/2024.
//

import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Query var activities: [Activity]
    var weather: ResponseBody

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
                Text("Scheduled Activities")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 30))
                    .padding(.top, 40)
                
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
                                scheduleCardView(activity: activity, weather: weather, weatherDate: selectedDay)
                                    .padding(.bottom, 10)
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
                    
                    
                    newSchedCardView(activity: activity, weather: weather, weatherDate: firstDailyDt)
                        .padding(.bottom,11)
                }
            }
            .padding()
            .foregroundColor(textColor)
        }
    }
    
    }

#Preview {
    do {
        let previewer = try ActivityPreviewer()

        return ScheduleView(weather: previewWeather)
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
                        PreviewConditionView(showingPopover: $showingPopover, activity: activity, weather: weather, weatherDate:weatherDate)
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
            let locationText = activity.location ?? "Unknown Location"
            let scheduledDay = activity.start?.convertToDayOfWeek() ?? "..."
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
                        Text("Good Conditions")
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
