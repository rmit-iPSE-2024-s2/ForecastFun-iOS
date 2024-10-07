//
//  ContentView.swift
//  A1
//
//  Created by Anthony Forti on 28/8/2024.
//


import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var locationManager = LocationManager()
    @State private var showTodayView: Bool = true
    @State private var forecast: UpcomingForecast? = nil

    var activities: [Activity]

    var weather: ResponseBody
    private var firstDailyDt: Int {
        return weather.daily.first?.dt ?? 0
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
                                fourDayView(weather: weather, activities: activities.filter { $0.added }, activity: activity)
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
                                        
                                        HStack{
                                            Image(systemName: "plus.square")
                                                .font(.system(size: 30))
                                                .fontWeight(.light)
                                                .opacity(0.9)
                                        }
                                        .frame(width: 60, height: 55)
                                        .padding()
                                        .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1))
                                            
                                    } else {
                                        ForEach(activities.filter { $0.added }, id: \.activityId) { activity in
                                            ActivityView(
                                                activities: activities.filter { $0.added }, // This could be optimized depending on your use case
                                                activity: activity,
                                                weather: weather,
                                                weatherDate: firstDailyDt
                                            )

                                            
                                            
                                        }
                                        
                                        HStack{
                                            Image(systemName: "plus.square")
                                                .font(.system(size: 30))
                                                .fontWeight(.thin)
                                                .opacity(0.9)
                                        }
                                        .frame(width: 60, height: 55)
                                        .padding()
                                        .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1))
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
                            nextScheduledView()
                            
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
        
        return HomeScreen(activities: activities, weather: previewWeather)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

struct nextScheduledView : View{
    var body: some View{
        VStack{
            HStack{
                VStack(spacing:2){
                    Text("MON")
                        .fontWeight(.bold)
                    Text("7AM")
                }
                .font(.system(size:23))
                .padding(15)
                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                
                VStack(spacing:13){
                    Text("Running @ Graham Park")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size:17.5))
                    HStack{
                        Text("Good Conditions")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            .font(.system(size:17))
                            .fontWeight(.semibold)
                            .padding(.bottom,2)
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
            
        }
        
        
    }
}



struct fourDayView: View {
    var weather: ResponseBody
    var activities: [Activity]
    var activity: Activity
    @State private var dayPopover = false
    @State private var activePopoverDay: Int? = nil
    @State private var showAlert = false
    
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
    
    var body: some View{
        VStack(spacing: 3) {
            Text("4-Day Forecast")
                .padding()
                .padding(.bottom, -5)
                .frame(width: 350, alignment: .leading)
                .overlay(
                    Rectangle()
                        .frame(width: 323, height: 2)
                        .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                        .opacity(0.7),
                    alignment: .bottom
                )
            
            ForEach(weather.daily.prefix(4), id: \.self) { day in
                HStack(spacing: 10) {
                    Rectangle()
                        .frame(width: 4, height: 24)
                        .foregroundColor(.green)
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
                        }
                    }) {
                        Image(systemName: "arrow.forward.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .popover(isPresented: Binding(
                        get: { activePopoverDay == day.dt }, // Show if activePopoverDay matches this day's dt
                        set: { if !$0 { activePopoverDay = nil } } // Dismiss by setting nil
                    )) {
                        PreviewConditionView(activities: activities, activity: activity, weather: weather, weatherDate:day.dt)
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


// create a day 
