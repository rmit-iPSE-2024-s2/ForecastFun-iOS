//
//  ActivityListView.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 8/10/2024.
//

import Foundation
import SwiftUI


struct ActivityListView: View {
    @State private var activities: [Activity] = []
    @State private var showAddActivitySheet = false
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let cardBackgroundColor = Color(red: 36/255, green: 50/255, blue: 71/255)
    let highlightColor = Color.blue
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(backgroundColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack {
                    if activities.isEmpty {
                        Text("No activities added")
                            .font(.headline)
                            .foregroundColor(textColor.opacity(0.7))
                            .padding()
                    } else {
                        List {
                            ForEach(activities) { activity in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(activity.activityName)
                                            .font(.headline)
                                            .foregroundColor(textColor)
                                        Spacer()
                                        Button(action: {
                                            deleteActivity(activity)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    
                                    // Displaying preferred weather conditions
                                    Text("Temperature: \(Int(activity.temperatureRange[0]))°C - \(Int(activity.temperatureRange[1]))°C")
                                        .foregroundColor(textColor.opacity(0.7))
                                        .font(.subheadline)
                                    Text("Wind: \(Int(activity.windRange[0])) km/h - \(Int(activity.windRange[1])) km/h")
                                        .foregroundColor(textColor.opacity(0.7))
                                        .font(.subheadline)
                                    Text("Precipitation: \(Int(activity.precipRange[0])) mm - \(Int(activity.precipRange[1])) mm")
                                        .foregroundColor(textColor.opacity(0.7))
                                        .font(.subheadline)
                                    Text("Humidity: \(Int(activity.humidityRange[0]))% - \(Int(activity.humidityRange[1]))%")
                                        .foregroundColor(textColor.opacity(0.7))
                                        .font(.subheadline)
                                }
                                .padding(.vertical, 8)
                                .listRowBackground(cardBackgroundColor)
                            }
                        }
                        .background(backgroundColor)
                        .scrollContentBackground(.hidden)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showAddActivitySheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .padding()
                            .background(highlightColor)
                            .foregroundColor(backgroundColor)
                            .clipShape(Circle())
                    }
                    .padding()
                    .sheet(isPresented: $showAddActivitySheet) {
                        AddActivityView(onAdd: { activity in
                            // Update precip range to always show 0-10 mm
                            var updatedActivity = activity
                            updatedActivity.precipRange = [0, 10]
                            activities.append(updatedActivity)
                        })
                    }
                }
                .navigationTitle("Your Activities")
                .foregroundColor(textColor)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func deleteActivity(_ activity: Activity) {
        activities.removeAll { $0.activityId == activity.activityId }
    }
}

struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView()
    }
}
