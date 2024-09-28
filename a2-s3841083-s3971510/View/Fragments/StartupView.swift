//
//  StartupView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 25/9/2024.
//

import SwiftUI
import CoreLocationUI

struct StartupView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing:30){
            Text("Welcome to Forecast Fun")
                .foregroundColor(Color(red:226/255, green:237/255, blue: 255/255, opacity: 1))
            Text("Please share you location to get started")
                .foregroundColor(Color(red:226/255, green:237/255, blue: 255/255, opacity: 1))
            
            LocationButton(.shareCurrentLocation){
                locationManager.requestLocation()
            }
            .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
            .background(Color(red:74/255, green:99/255, blue: 143/255, opacity: 1))
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 43/255, green:58/255 , blue: 84/255, opacity: 1.0))
    }
        
}

#Preview {
    StartupView()
}
