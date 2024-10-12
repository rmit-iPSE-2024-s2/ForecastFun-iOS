//
//  SplashScreenView.swift
//  A1
//
//  Created by Francis Z on 31/8/2024.
//

import SwiftUI
import CoreLocation

/// Splash screen that previews the logo and introduces the app to the app
struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?


    var body: some View {
        // change t
        if isActive{
            
            if let location = locationManager.retrieveSavedLocation() {
                if let weather = weather {
                    MainTabbedView(weather: weather, location: location)
                } else{
                    ProgressView()
                        .tint(Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0))
                        .task{
                            do{
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            }catch{
                                print("Error fetching weather data")
                            }
                        }
                }
            }
            else if let location = locationManager.location{
                if let weather = weather {
                    MainTabbedView(weather: weather, location: location)
                } else{
                    ProgressView()
                        .tint(Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0))
                        .task{
                            do{
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            }catch{
                                print("Error fetching weather data")
                            }
                        }
                }
            }
            else{
                if locationManager.isLoading{
                    ProgressView()
                } else{
                    StartupView()
                        .environmentObject(locationManager)
                }
            }
            

            
            
        }
        else{
            ZStack{
                Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0)
                    .ignoresSafeArea(.all)
            VStack{
                VStack{
                    Image(systemName: "cloud")
                        .font(.system(size: 60))
                    Text("Forecast Fun")
                        .font(.system(size:20))
                        .padding()
                        
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration:1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
                .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
            }}
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                    
                }
            }
        }
        }
    
}

#Preview {
    SplashScreenView()
}
