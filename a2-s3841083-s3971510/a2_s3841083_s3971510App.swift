//
//  a2_s3841083_s3971510App.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 11/9/2024.
//

import SwiftUI
import SwiftData

@main
struct a2_s3841083_s3971510App: App {

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .modelContainer(appContainer)
        }
    }
}


@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Activity.self)
        
        // Make sure the persistent store is empty if it's not, return the non-empty container
        var itemFetchDescriptor = FetchDescriptor<Activity>()
        itemFetchDescriptor.fetchLimit = 1
        let allActivities = try container.mainContext.fetch(itemFetchDescriptor)
                
        // Get the current timestamp
        let currentTimestamp = Date().timeIntervalSince1970
        
        // Filter out outdated scheduled activities and delete them
        for activity in allActivities where activity.scheduled && (activity.start != nil && Double(activity.start!) < currentTimestamp) {
            container.mainContext.delete(activity)
        }
        
        // If the persistent store is empty (on first startup) populate the database with activities
        guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else { return container }
        
        // This code will only run if the persistent store is empty.
        // It initialises activities available to be added/scheduled by the user
        let activities = [
            Activity(
                activityId: 1,
                activityName: "Walking",
                humidityRange: [40, 60],
                temperatureRange: [15.0, 25.0],
                windRange: [0.0, 5.0],
                precipRange: [0.0, 0.1],
                keyword: "outdoor",
                added: false,
                scheduled: false
            ),
            Activity(
                activityId: 2,
                activityName: "Running",
                humidityRange: [30, 50],
                temperatureRange: [10.0, 20.0],
                windRange: [0.0, 10.0],
                precipRange: [0.0, 0.05],
                keyword: "outdoor",
                added: false,
                scheduled: false
            ),
            Activity(
                activityId: 3,
                activityName: "Biking",
                humidityRange: [20, 40],
                temperatureRange: [18.0, 30.0],
                windRange: [5.0, 15.0],
                precipRange: [0.0, 0.1],
                keyword: "outdoor",
                added: false,
                scheduled: false
            ),
            Activity(
                activityId: 4,
                activityName: "Swimming",
                humidityRange: [50, 60],
                temperatureRange: [25.0, 30.0],
                windRange: [5.0, 20.0],
                precipRange: [0.0, 0.0],
                keyword: "beach",
                added: false,
                scheduled: false
            ),
            Activity(
                activityId: 5,
                activityName: "Hiking",
                humidityRange: [30, 50],
                temperatureRange: [10.0, 20.0],
                windRange: [0.0, 15.0],
                precipRange: [0.0, 0.2],
                keyword: "outdoor",
                added: false,
                scheduled: false
            ),
            Activity(
                activityId: 6,
                activityName: "Basketball",
                humidityRange: [40, 60],
                temperatureRange: [15.0, 25.0],
                windRange: [0.0, 10.0],
                precipRange: [0.0, 0.1],
                keyword: "basketball",
                added: false,
                scheduled: false
            ),
            Activity(
                activityId: 7,
                activityName: "Golf",
                humidityRange: [30, 70],
                temperatureRange: [20.0, 30.0],
                windRange: [0.0, 15.0],
                precipRange: [0.0, 0.1],
                keyword: "golf",
                added: false,
                scheduled: false
            ),
            Activity(
                activityId: 8,
                activityName: "Picnic",
                humidityRange: [40, 60],
                temperatureRange: [18.0, 26.0],
                windRange: [0.0, 5.0],
                precipRange: [0.0, 0.05],
                keyword: "park",
                added: false,
                scheduled: false
            )
        ]


        
        for activity in activities {
            container.mainContext.insert(activity)
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
