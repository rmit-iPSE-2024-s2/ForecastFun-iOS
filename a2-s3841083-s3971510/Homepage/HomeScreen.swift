//
//  ContentView.swift
//  A1
//
//  Created by Anthony Forti on 28/8/2024.
//

let todayForecast = DayForecast(
    day: "Monday",
    temp: "22°C",
    maxTemp: "24°C",
    minTemp: "20°C",
    mainCondition: "sun.min.fill",
    humidity: "60%",
    precipitation: "0 mm",
    wind: "15 km/h"
)


import SwiftUI

struct HomeScreen: View {
    @State private var showTodayView: Bool = true
    @State private var forecast: UpcomingForecast? = nil
    var icons = ["precipitation", "24" ,"6", "11"]
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 218/255, green:210/255 , blue: 240/255, opacity: 1.0)
                    .ignoresSafeArea(.all)
                VStack {
                    
                    
                    VStack{
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
                                .padding(.leading, 30)

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
                            .padding(.trailing, 20)
                            
                        }
                        

                        Text("Melbourne, Victoria")
                            .padding()
                    }


                    
                    if showTodayView{
                        Image(systemName: "\(todayForecast.mainCondition)")
                            .resizable()
                            .frame(width: 160, height: 160)
                            .foregroundColor(Color(red: 255/255, green:235/255 , blue: 101/255, opacity: 1.0))
                                    
                        AnyLayout(TriangleLayout()) {
                            ForEach(WeatherDetail.allCases, id: \.self) { detail in
                                VStack {
                                    if detail == .temperature {
   
                                        Text(detail.value(from: todayForecast))
                                            .font(.system(size: 45))
                                    } else {

                                        Text(detail.label)
                                        Text(detail.value(from: todayForecast))
                                    }
                                }
                            }
                        }.padding(50)
                        
//                        Text("21°C")
//                            .font(.system(size:40))
//                        HStack{
//                            Text("Humidity: 20%")
//                                .multilineTextAlignment(.center)
//                                .padding()
//                            Text("Precipitation: 0mm")
//                                .multilineTextAlignment(.center)
//                                .padding()
//                            Text("Wind: 3km/h")
//                                .multilineTextAlignment(.center)
//                                .padding()
//                        }
                    }
                    else{
                        fourDayView(forecast: $forecast)
                    }
                    Text("It's a great time to enjoy your favourite activities outside!")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    ActivityView(title:"Walking", bgColor: Color(red: 130/255, green:218/255 , blue: 171/255, opacity: 1.0))
                    
                    
                    

                }
                .padding(25)
                .offset(y:-20)
                .foregroundColor(Color(red: 55/255, green:31/255 , blue: 92/255, opacity: 1.0))
            }


            
        }
    }
    
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

struct ActivityView: View {
    var title: String
    var bgColor: Color
    //optional

    var body: some View {
        VStack{
            HStack {

                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(.title))
                    .foregroundColor(.white)
                
                NavigationLink(destination:RecActivityView()){
                Image(systemName: "ellipsis")
                    .resizable()
                    .frame(width:35, height:7.5)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(90))}


            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20)
            .padding(20)
            .background(bgColor)
            .cornerRadius(20)
            
            HStack{
                VStack{
                    HStack{
                        Text("Temperature")
                            
                        Circle()
                            .frame(width: 10, height:10)
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    
                    
                    HStack
                    {
                        Text("Precipitation")
                            
                        Circle()
                            .frame(width: 10, height:10)
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                }

                
                
                VStack{
                    HStack{
                        Text("Humidity")
                            
                        Circle()
                            .frame(width: 10, height:10)
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    
                    HStack
                    {
                        Text("Wind")
                            
                        Circle()
                            .frame(width: 10, height:10)
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                }
              
            }
        }
    }
}




struct fourDayView: View {
    @Binding var forecast: UpcomingForecast?
    
    var body: some View{
        VStack() {
                    ForEach(UpcomingForecast.allCases, id: \.self) { item in
                        
                       
                        
                        HStack {
                            Text(item.title)
                                .padding([.top, .bottom, .trailing], 1.5)
                                .frame(width: 60)
                                .font(.system(size:20))
                            
                            ForEach(item.dayForecast, id: \.self){ dayItem in
                                Image(systemName: dayItem.mainCondition)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 23, height: 23)
                                    .foregroundColor(Color(red: 55/255, green: 31/255 , blue: 92/255, opacity: 1.0))
                                Spacer()
                                Text("L:\(dayItem.minTemp)")
                                Spacer()
                                Text("H:\(dayItem.maxTemp)")
                            }
                            
                            
                            Spacer()
                            
                            
                            
                            Text("2")
                                .padding([.trailing, .leading],6)
                                .font(.system(size:29))
                                .foregroundColor(.white)
                                .background(Color(red: 130/255, green:218/255 , blue: 171/255, opacity: 1.0))
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                        }
                        .padding([.top, .bottom, .trailing])
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color(red: 55/255, green: 31/255 , blue: 92/255, opacity: 1.0)),
                            alignment: .bottom
                        )
                        .onTapGesture {
                            withAnimation {
                                self.forecast = item
                    }
                }
            }

        }
        .padding([.top, .bottom, .trailing])
        .frame(maxWidth: .infinity, alignment: .leading)
        
        
    }
}

enum WeatherDetail: CaseIterable {
    case temperature
    case humidity
    case precipitation
    case wind
    
    // Function to get the label for each case
    var label: String {
        switch self {
        case .temperature:
            return "Temperature"
        case .humidity:
            return "Humidity"
        case .precipitation:
            return "Precipitation"
        case .wind:
            return "Wind"
        }
    }
    
    // Function to get the value for each case from a DayForecast instance
    func value(from forecast: DayForecast) -> String {
        switch self {
        case .temperature:
            return forecast.temp
        case .humidity:
            return forecast.humidity
        case .wind:
            return forecast.wind
        case .precipitation:
            return forecast.precipitation
        
        }
    }
}
