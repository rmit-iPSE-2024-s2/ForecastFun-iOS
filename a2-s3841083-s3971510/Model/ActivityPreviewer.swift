//
//  Previewer.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 3/10/2024.
//

import Foundation
import SwiftData

@MainActor
struct ActivityPreviewer {
    let container: ModelContainer
    let activities: [Activity]

    init() throws {

        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Activity.self, configurations: config)

        // Creating multiple Activity instances
        let walkingActivity = Activity(
            activityId: 1,
            activityName: "Walking",
            humidityRange: [40, 60],
            temperatureRange: [15.0, 25.0],
            windRange: [0.0, 5.0],
            precipRange: [0.0, 0.1],
            keyword: "outdoor",
            added: false,
            scheduled: false
        )

        let runningActivity = Activity(
            activityId: 2,
            activityName: "Running",
            humidityRange: [30, 50],
            temperatureRange: [10.0, 20.0],
            windRange: [0.0, 10.0],
            precipRange: [0.0, 0.05],
            keyword: "outdoor",
            added: false,
            scheduled: false
        )

        let bikingActivity = Activity(
            activityId: 3,
            activityName: "Biking",
            humidityRange: [20, 40],
            temperatureRange: [18.0, 30.0],
            windRange: [5.0, 15.0],
            precipRange: [0.0, 0.1],
            keyword: "outdoor",
            added: false,
            scheduled: false
        )
        
        let bikingAdded = Activity(
            activityId: 3,
            activityName: "Biking",
            humidityRange: [20, 40],
            temperatureRange: [18.0, 30.0],
            windRange: [5.0, 15.0],
            precipRange: [0.0, 0.1],
            keyword: "outdoor",
            added: true,
            scheduled: false
        )

        // Store activities in an array
        activities = [walkingActivity, runningActivity, bikingActivity, bikingAdded]

        // Insert activities into the in-memory context
        for activity in activities {
            container.mainContext.insert(activity)
        }
    }
}

