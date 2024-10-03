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
    let walkingActivity: Activity

    init() throws {
        // In-memory container for preview/testing purposes
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Activity.self, configurations: config)

        // Creating a sample Activity instance
        walkingActivity = Activity(
            activityId: 1,
            activityName: "Walking",
            humidityRange: [40, 60],
            temperatureRange: [15.0, 25.0],
            windRange: [0.0, 5.0],
            precipRange: [0.0, 0.1],
            keyword: "outdoor"
        )

        // Insert the activity into the in-memory context
        container.mainContext.insert(walkingActivity)
    }
}

