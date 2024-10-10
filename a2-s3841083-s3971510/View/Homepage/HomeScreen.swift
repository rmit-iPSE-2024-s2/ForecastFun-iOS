//
//  ContentView.swift
//  A1
//
//  Created by Anthony Forti on 28/8/2024.
//


import SwiftUI
import SwiftData
import CoreLocation

struct HomeScreen: View {
    
    @Environment(\.modelContext) private var context
    @StateObject var locationManager = LocationManager()
    @State private var showTodayView: Bool = true
    @State private var forecast: UpcomingForecast? = nil
    @Query var activities: [Activity]
    @State private var showAddActivitySheet = false
    
    
    var weather: ResponseBody
    var location: CLLocationCoordinate2D
    
    
    private var firstDailyDt: Int {
        return weather.daily.first?.dt ?? 0
    }
    
    private func addActivity(_ activity: Activity) {
        context.insert(activity)
    }
    
    var body: some View {
        NavigationView{
            
            
            ZStack{
                Color(red: 43/255, green:58/255 , blue: 84/255, opacity: 1.0)
                    .ignoresSafeArea(.all)
                VStack(spacing:20) {
                    
                    
                    VStack(){
                        HStack{
                            HStack{
                                Button(action: {
                                    withAnimation(.spring()) {
                                        
                                        if !showTodayView {
                                            showTodayView.toggle()
                                        }
                                    }
                                }) {
                                    Image(systemName: showTodayView ? "circlebadge.fill" :"circlebadge")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }
                                
                                Text("Today")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.leading, 65)
                            
                            HStack{
                                Button(action: {
                                    withAnimation(.spring()) {
                                        if showTodayView{
                                            showTodayView.toggle()
                                        }
                                        
                                    }
                                }) {
                                    Image(systemName: !showTodayView ? "circlebadge.fill" :"circlebadge")
                                        .resizable()
                                        .frame(width:15, height:15)
                                }
                                
                                
                                
                                Text("4-Day View")
                                
                                
                            }
                            .padding(.horizontal, 40)
                            
                        }
                        
                    }
                    
                    if showTodayView{
                        VStack(spacing:0){
                            
                            HStack(spacing:10)
                            {
                                let weatherIcon = weather.current.weather.first?.icon ?? "default"
                                let iconName = getIconName(from: weatherIcon)
                                Image(iconName)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                
                                
                                VStack{
                                    let locationName = weather.timezone.split(separator: "/")
                                    let state = locationName[1].replacingOccurrences(of: "_", with: " ")
                                    let country = locationName[0].replacingOccurrences(of: "_", with: " ")
                                    Text("\(weather.current.temp.roundDouble())°C")
                                        .font(.system(size:60))
                                        .fontWeight(.thin)
                                    Text("\(state), \(country)")
                                        .font(.system(size:14))
                                }.padding(.horizontal)
                                
                            }
                            .padding()
                            .overlay(
                                Rectangle()
                                    .frame(width: 323, height: 1.5)
                                    .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255, opacity: 0.7)), alignment: .bottom
                            )
                            
                            HStack(spacing:5){
                                
                                VStack{
                                    Text("\(weather.current.wind_speed.roundDouble())km/h")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:20))
                                    
                                    Text("Wind")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:15))
                                }
                                
                                VStack{
                                    Text("\(weather.current.humidity)%")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:20))
                                    Text("Humidity")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:15))
                                }
                                
                                
                                VStack{
                                    Text("\(weather.precipitation.roundDouble())mm")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:20))
                                    
                                    Text("Precipitation")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:15))
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.leading, 40)
                            .padding(.top, 27)
                            .padding(.bottom, 6)
                            
                            
                            
                        }
                    }
                    
                    else{
                        VStack(spacing: 10){
                            if let activity = activities.first {
                                fourDayView(weather: weather, activity: activity, location: location)
                            }


                        }
                    }
                    
                    
                    VStack(spacing:-2){
                        VStack(spacing:-12)
                        {
                            Text("Activities Today")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 30)
                            ScrollView(.horizontal, showsIndicators: false ){
                                
                                HStack {
                                    if activities.filter({ $0.added }).isEmpty {
                                        HStack{
                                            VStack(alignment: .leading, spacing: 5){
                                                Text("No Liked Activities")
                                                    .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                                                    .font(.headline)
                                                Text("Please add an acitivity")
                                                    .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.7))
                                                    .font(.headline)
                                            }
                                            Spacer()
                                            
                                        }
                                        .frame(width: 225, height: 55)
                                        .padding()
                                        .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1)
                                        )
                                        
                                        
                                       
                                        Button(action: {
                                            showAddActivitySheet = true
                                        }) {
                                            HStack{
                                                Image(systemName: "plus.square")
                                                    .font(.system(size: 40))
                                                    .fontWeight(.light)
                                                    .opacity(0.8)
                                            }
                                            .frame(width: 65, height: 55)
                                            .padding()
                                            .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
                                            .cornerRadius(15)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1))
                                        }
                                        .sheet(isPresented: $showAddActivitySheet) {
                                            AddActivityView(onAdd: { activity in
                                                let updatedActivity = activity
                                                updatedActivity.added = true
                                                addActivity(updatedActivity)
                                            })
                                        }
                                            
                                    } else {
                                        ForEach(activities.filter { $0.added }, id: \.activityId) { activity in
                                            ActivityView(
                                                activity: activity,
                                                weather: weather,
                                                weatherDate: firstDailyDt,
                                                location: location
                                            )

                                            
                                            
                                        }
                                        
                                        Button(action: {
                                            showAddActivitySheet = true
                                        }) {
                                            HStack{
                                                Image(systemName: "plus.square")
                                                    .font(.system(size: 40))
                                                    .fontWeight(.light)
                                                    .opacity(0.8)
                                            }
                                            .frame(width: 65, height: 55)
                                            .padding()
                                            .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
                                            .cornerRadius(15)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1))
                                        }
                                        .sheet(isPresented: $showAddActivitySheet) {
                                            AddActivityView(onAdd: { activity in
                                                let updatedActivity = activity
                                                updatedActivity.added = true
                                                addActivity(updatedActivity)
                                            })
                                        }
                                    }
                                }
                                .padding(20)
                            }
                        }
                        
                        VStack{
                            Text("Next Scheduled Activity")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 30)
                            if let activity = activities.first {
                                nextScheduledView(activity: activity, weather: weather, weatherDate: firstDailyDt, location: location)
                                newSchedCardView(activity: activity, weather: weather, weatherDate: firstDailyDt, location: location)
                            }
                            
                            Spacer()
                            
                        }
                        .frame(height:217)
                    }
                    
                }
                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
            }
            
            
            
        }
        
        
    }
    
    
}



#Preview {
    do {
        let previewer = try ActivityPreviewer()
        let mockLocation = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        return HomeScreen(weather: previewWeather, location: mockLocation)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

struct nextScheduledView : View{
    @Query var activities: [Activity]
    var activity: Activity
    var weather: ResponseBody
    var weatherDate: Int
    var location: CLLocationCoordinate2D
    @State private var showAlert = false
    @State private var showingPopover = false
      
    var scheduledActivities: [Activity]? {
        return activities.filter { $0.scheduled }
    }
    
    var upcomingActivity: Activity? {
        if let scheduledActivities = scheduledActivities{
            return scheduledActivities.min(by: {
                ($0.start ?? Int.max) < ($1.start ?? Int.max)
            })
        }
        else{
            return nil
        }
    }
    

    
    var body: some View{
        VStack{
            

            if let upcomingActivity = upcomingActivity {
                
                let locationText = (upcomingActivity.location?.isEmpty == false ? upcomingActivity.location : "TBD") ?? "TBD"
                
                let scheduledDay = upcomingActivity.start?.convertToDayOfWeek() ?? "..."

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
                        
                        Text("\(upcomingActivity.activityName) @ \(locationText)")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size:17.5))
                        HStack{
                            Text("\(upcomingActivity.conditionText ?? "No Condition")")
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
            else{
                HStack{
                    VStack(spacing:13){

                        Text("No Scheduled Activities")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(3.0)
                            .font(.system(size:17))
                            .fontWeight(.semibold)
                            .padding(.bottom,1)
                        
                        Text("Please Schedule an Activity")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            .font(.system(size:17))
                            .fontWeight(.semibold)
                            .padding(.bottom,1)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)

                        
                    }
                    .padding()
                    .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 7.0))
                    
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
    
}



struct fourDayView: View {
    var weather: ResponseBody
    var activity: Activity
    var location: CLLocationCoordinate2D
    
    @Query var activities: [Activity]
    @State private var activePopoverDay: Int? = nil
    @State private var showingPopover = false
    @State private var showAlert = false
    @State private var showInfo = false
    
    var body: some View{
        
        VStack(spacing: 3) {
            HStack{
                Text("4-Day Forecast")
                
                Spacer()
                
                
                
                Button(action: {
                    withAnimation { // Animate the toggle
                        showInfo.toggle()
                    }
                }) {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }

                
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 42)

            
            

            Rectangle()
                .frame(width: 321, height: 1)
                .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                .opacity(0.7)
            
            if showInfo {
                ZStack{
                    VStack(alignment: .leading, spacing: 5) {
                        Text("How it works")
                            .font(.headline)
                        
                        Rectangle()
                            .frame(width: 260, height: 1)
                            .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                            .opacity(0.7)
                        
                        VStack(alignment: .leading){
                            Text("The conditions (color) is based on the number of liked activities that are suited for the corresponding day")
                                .padding(.vertical)


                        }
                        .font(.system(size: 15))
                        Rectangle()
                            .frame(width: 260, height: 1)
                            .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                            .opacity(0.7)
                        
                        Button("Got it!") {
                            withAnimation {
                                showInfo = false  // Close the info VStack
                            }
                        }
                        .padding(.top, 5)
                    }
                    .frame(width: 283, height: 170)
                    .padding(13)
                    .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
                    .cornerRadius(8)
                    .padding(.horizontal, 42)
                    .transition(.slide)
                }
                .padding(.top)
                
            }
            else{
                ForEach(weather.daily.prefix(4), id: \.self) { day in
                    HStack(spacing: 10) {
                        Rectangle()
                            .frame(width: 4, height: 24)
                            // if theres no activites, turn blue
                            // otherwise find whether the day is suitable for your activities
                            
                            .foregroundColor( activities.filter({ $0.added }).isEmpty ? .blue :
                                // color representing if conditions are suitable for added activities
                                              getConditionColorForDay(
                                                addedActivities:activities.filter{ $0.added },
                                                currentTemp: day.temp.day,
                                                currentPrecip: day.dailyPrecipitation,
                                                currentHumidity: day.humidity,
                                                currentWind: day.wind_speed
                                              )
                            )
                            .opacity(0.7)
                            .padding(.leading, 17)


                        
                        Text(day.dt.convertToDayOfWeek()) // Convert the timestamp to the day of the week
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(width: 46, alignment: .leading)
                            
                        
                        
                        HStack(spacing: 20) {
                            // Weather Icon
                            Image(systemName: getWeatherIcon(for: day.weather.first?.id ?? 0))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255, opacity: 1.0))
                            
                            // Temperature Details
                            Text("L: \(day.temp.min.roundDouble())°C")
                                .frame(width: 70, alignment: .leading)
                            Text("H: \(day.temp.max.roundDouble())°C")
                        }
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Button(action: {
                            if activities.filter({ $0.added }).isEmpty {
                                // Show alert if there are no added activities
                                showAlert = true
                            } else {
                                // Set the active popover day if activities are present
                                activePopoverDay = day.dt
                                showingPopover = true
                            }
                        }) {
                            Image(systemName: "arrow.forward.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .popover(isPresented: Binding(
                            get: { activePopoverDay == day.dt && showingPopover },
                            set: { newValue in
                                if !newValue {
                                    // Close the popover by resetting the active day and showingPopover
                                    activePopoverDay = nil
                                    showingPopover = false
                                }
                            }
                        )) {
                            PreviewConditionView(showingPopover: $showingPopover, activity: activity, weather: weather, weatherDate: day.dt, location: location)
                        }
                        .padding(.trailing, 20)
                        
                        
                    }
                    .padding(.vertical, 8)
                    .frame(width: 350, alignment: .leading)

                    Rectangle()
                        .frame(width: 323, height: 1.5)
                        .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255, opacity: day == weather.daily.prefix(4).last ? 0 : 0.4))
                }
            }
        }
        .background(Color(red:74/255, green:99/255, blue:143/255, opacity:0))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .center)
        .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("No Liked Activities"),
                        message: Text("You don't have any liked activities to view the conditions"),
                        dismissButton: .default(Text("OK"))
                    )
        }
    }
    
}

func getIconName(from icon: String) -> String {
    switch icon {
    case "01d":
        return "clear-day"
    case "01n":
        return "clear-night"
    case "02d", "03d", "04d":
        return "cloudy"
    case "02n", "03n", "04n":
        return "partly-cloudy-night"
    case "09d", "10d":
        return "showers"
    case "09n", "10n":
        return "showers"
    case "11d", "11n":
        return "thunderstorm-showers"
    case "13d", "13n":
        return "snow"
    case "50d", "50n":
        return "fog"
    default:
        return "cloudy"
    }
}

func getWeatherIcon(for weatherID: Int) -> String {
    switch weatherID {
    case 200...232: // Thunderstorm
        return "cloud.bolt.rain.fill"
    case 300...321: // Drizzle
        return "cloud.drizzle.fill"
    case 500...531: // Rain
        return "cloud.rain.fill"
    case 600...622: // Snow
        return "snowflake"
    case 701...781: // Atmosphere (fog, haze, etc.)
        return "cloud.fog.fill"
    case 800:       // Clear
        return "sun.max.fill"
    case 801...804: // Clouds
        return "cloud.fill"
    default:        // Unknown case
        return "questionmark"
    }
}
// create a day
