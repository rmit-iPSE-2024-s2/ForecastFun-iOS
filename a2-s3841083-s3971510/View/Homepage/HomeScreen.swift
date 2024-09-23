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
    mainCondition: "sun.and.horizon.fill",
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
                Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0)
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
                        VStack(spacing:35){
                        
                            HStack(spacing:25)
                            {
                                Image(systemName: "\(todayForecast.mainCondition)")
                                    .resizable()
                                    .frame(width: 130, height: 81)
                                    .foregroundColor(Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0))
                                    .padding()
                                            
                                
                                VStack{
                                    Text("21°C")
                                        .font(.system(size:60))
                                        .fontWeight(.thin)
                                    Text("Melbourne, Victoria")
                                        .font(.system(size:13))
                                }
                                .padding()
                            }
                            .padding(.top,30)
      
                            HStack(spacing:5){
                                
                                VStack{
                                    Text("2km/h")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:20))
                                    
                                Text("Wind")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:15))
                                }
                                
                                VStack{
                                    Text("20%")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:20))
                                    Text("Humidity")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size:15))
                                }
                                
                                
                                VStack{
                                    Text("0mm")
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
              
               
                        }
                    }
                    
                    else{
                        fourDayView(forecast: $forecast)
                    }
                    
                    VStack(spacing:-2){
                        VStack(spacing:-12)
                            {
                                Text("Activities Now")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 30)
                                ScrollView(.horizontal, showsIndicators: false ){
                                    HStack
                                        {
                                            ActivityView(title:"Walking", bgColor: Color(red: 130/255, green:218/255 , blue: 171/255, opacity: 1.0))
                                            ActivityView(title:"Running", bgColor: Color(red: 130/255, green:218/255 , blue: 171/255, opacity: 1.0))
                                        }
                                        .padding(20)
                                }
                            }
                        
                        VStack{
                            Text("Scheduled Activity")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 30)
                            nextScheduledView()
                            nextScheduledView()
                        }
                    }
                    
                }

                .foregroundColor(Color(red: 59/255, green:57/255 , blue: 52/255, opacity: 1.0))
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

    var body: some View {
        VStack{
            VStack(spacing:5){
                    HStack {
                        
                        Text(title)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size:18))
                                .foregroundColor(Color(red: 59/255, green:57/255 , blue: 52/255, opacity: 1.0))
                        
                        NavigationLink(destination:RecActivityView()){
                        Image(systemName: "arrow.forward.circle.fill")
                            .resizable()
                            .frame(width:25, height:25)
                            .foregroundColor(Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0))
                            }
                        
                        
                        }
                    Text("Good Conditions")
                            .padding(5)
                            .background(Color(red: 138/255, green:194/255 , blue: 150/255, opacity: 1.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .font(.system(size:15))
                        
            }
            .padding(12)
            .background(Color(red:199/255, green:217/255, blue: 244/255, opacity: 1))
            .cornerRadius(20)
            .frame(width: 230)
            
        }
    }
}


struct nextScheduledView : View{
    var body: some View{
        HStack{
            VStack(spacing:2){
                Text("MON")
                    .fontWeight(.bold)
                Text("7AM")
            }
            .font(.system(size:25))
            .padding(14)
            .foregroundColor(Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0))
            
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
                        .padding(.bottom,2)
                }
                .foregroundColor(Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 0.7))
                
            }
            .foregroundColor(Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0))

        }
        .background(Color(red:199/255, green:217/255, blue: 244/255, opacity: 1))
        .cornerRadius(20)
        .frame(width: 360)
    }
}



struct fourDayView: View {
    @Binding var forecast: UpcomingForecast?
    
    var body: some View{
        VStack {
                    ForEach(UpcomingForecast.allCases, id: \.self) { item in
                        
                        HStack(spacing:20) {
                            Text(item.title)
                                .font(.system(size:20))
                                .fontWeight(.semibold)
                                .frame(width: 46, alignment: .leading)
                                .padding(.leading, 8)
                                
                            
                            ForEach(item.dayForecast, id: \.self){ dayItem in
                                HStack(spacing:20){
                                    Image(systemName: dayItem.mainCondition)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 23)
                                        .foregroundColor(Color(red: 55/255, green: 31/255 , blue: 92/255, opacity: 1.0))
                                    
                                    Text("L: \(dayItem.minTemp)")
                                    Text("H: \(dayItem.maxTemp)")
                                }
                                .font(.system(size:20))
                                .fontWeight(.regular)
                                .frame(width: 200, alignment: .leading)
                            }

                            Text("2")
                                .padding([.trailing, .leading],6)
                                .font(.system(size:20))
                                .foregroundColor(.white)
                                .background(Color(red: 130/255, green:218/255 , blue: 171/255, opacity: 1.0))
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                        }
                        .padding(12)
                        .frame(width:353, alignment: .leading)
                        .overlay(
                            Rectangle()
                                .frame(width: 323, height: 3)
                                .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255, opacity: item == UpcomingForecast.allCases.last ? 0 : 0.7)),
                            alignment: .bottom
                        )
                        .onTapGesture {
                            withAnimation {
                                self.forecast = item
                    }
                }
            }
                    .padding(.bottom, 2.5)

        }
        .background(Color(red:199/255, green:217/255, blue: 244/255, opacity: 1))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .center)
        
        
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
