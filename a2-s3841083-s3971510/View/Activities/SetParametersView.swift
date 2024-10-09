//
//  SetParametersView.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 8/10/2024.
//

import Foundation
import SwiftUI

struct SetParametersView: View {
    @State var activity: Activity
    let onSave: (Activity) -> Void
    
    @State private var tempLowerBound: Double = 15
    @State private var tempUpperBound: Double = 25
    @State private var windLowerBound: Double = 0
    @State private var windUpperBound: Double = 10
    @State private var precipLowerBound: Double = 0
    @State private var precipUpperBound: Double = 1
    @State private var humidityLowerBound: Double = 30
    @State private var humidityUpperBound: Double = 50
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let cardBackgroundColor = Color(red: 36/255, green: 50/255, blue: 71/255)
    let highlightColor = Color.blue
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Activity: \(activity.activityName)")
                    .font(.largeTitle)
                    .foregroundColor(textColor)
                    .padding(.top, 16)
                
                Form {
                    Section(header: Text("Ideal Ranges of Weather Conditions").foregroundColor(textColor)) {
                        VStack(alignment: .leading) {
                            Text("Temp Range (\(Int(tempLowerBound))°C - \(Int(tempUpperBound))°C)")
                                .foregroundColor(textColor)
                            Slider(value: $tempLowerBound, in: 0...tempUpperBound, step: 1.0)
                                .accentColor(highlightColor)
                            Slider(value: $tempUpperBound, in: tempLowerBound...40, step: 1.0)
                                .accentColor(highlightColor)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Wind Range (km/h) (\(Int(windLowerBound)) - \(Int(windUpperBound)))")
                                .foregroundColor(textColor)
                            Slider(value: $windLowerBound, in: 0...windUpperBound, step: 1.0)
                                .accentColor(highlightColor)
                            Slider(value: $windUpperBound, in: windLowerBound...20, step: 1.0)
                                .accentColor(highlightColor)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Precipitation Range (mm) (\(Int(precipLowerBound)) - \(Int(precipUpperBound)))")
                                .foregroundColor(textColor)
                            Slider(value: $precipLowerBound, in: 0...precipUpperBound, step: 0.1)
                                .accentColor(highlightColor)
                            Slider(value: $precipUpperBound, in: precipLowerBound...10, step: 0.1)
                                .accentColor(highlightColor)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Humidity (%) (\(Int(humidityLowerBound))% - \(Int(humidityUpperBound))%)")
                                .foregroundColor(textColor)
                            Slider(value: $humidityLowerBound, in: 0...humidityUpperBound, step: 1.0)
                                .accentColor(highlightColor)
                            Slider(value: $humidityUpperBound, in: humidityLowerBound...100, step: 1.0)
                                .accentColor(highlightColor)
                        }
                    }
                    .listRowBackground(cardBackgroundColor)
                }
                .background(backgroundColor.ignoresSafeArea())
                .scrollContentBackground(.hidden)
                
                // Reset to Default Button
                Button(action: {
                    resetToDefault()
                }) {
                    Text("Reset to Default")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                // Save Button
                Button(action: {
                    let activityToBeAdded = Activity(
                        activityId: Int.random(in: 10...100), activityName: activity.activityName, humidityRange: [Int(humidityLowerBound), Int(humidityUpperBound)], temperatureRange: [tempLowerBound, tempUpperBound], windRange: [windLowerBound, windUpperBound], precipRange: [precipLowerBound, precipUpperBound], keyword: activity.keyword, added: true, scheduled: false) // Adjust initialization based on your Activity model
                        

                        // Call the onSave closure with the new activity
                        onSave(activityToBeAdded)
                }) {
                    Text("Add Activity")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(highlightColor)
                        .foregroundColor(backgroundColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 5) // Add bottom padding to align it correctly
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .foregroundColor(textColor)
    }
    
    private func resetToDefault() {
        tempLowerBound = 15
        tempUpperBound = 25
        windLowerBound = 0
        windUpperBound = 10
        precipLowerBound = 0
        precipUpperBound = 1
        humidityLowerBound = 30
        humidityUpperBound = 50
    }
}
