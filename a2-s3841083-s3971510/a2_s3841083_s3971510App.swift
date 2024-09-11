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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
