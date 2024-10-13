//
//  ActivityListView.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 8/10/2024.
//

import SwiftUI
import SwiftData

/// View that list all activities that are added
struct ActivityListView: View {
    @Environment(\.modelContext) private var context
    @Query private var activities: [Activity]
    @State private var showAddActivitySheet = false
    // Defines the background colour, card colour, highlight colour and text colour for the activities page.
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let cardBackgroundColor = Color(red: 36/255, green: 50/255, blue: 71/255)
    let highlightColor = Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.7)
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    // Customises the appearance of the page to match the view of the colours and text.
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(backgroundColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    // Contains a list of activities, if there are none, it will say 'No activities added'.
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack {
                    if activities.filter({ $0.added }).isEmpty {
                        Text("No activities added")
                            .font(.headline)
                            .foregroundColor(textColor.opacity(0.7))
                            .padding()
                    } else {
                        // Displays the list of activities.
                        List {
                            ForEach(activities.filter { $0.added }, id: \.activityId) { activity in
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    // Activity name and deletion button.
                                    HStack {
                                        Text(activity.activityName)
                                            .font(.headline)
                                            .foregroundColor(textColor)
                                        Spacer()
                                        Button(action: {
                                            deleteItems(at: IndexSet(integer: activities.filter{ $0.added }.firstIndex(of: activity)!))
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
                            .onDelete(perform: deleteItems)
                        }
                        .listRowSpacing(10.0)
                        .padding(6)
                        .background(backgroundColor)
                        .scrollContentBackground(.hidden)
                    }

                    Spacer()
                    // Button to allow you to add a new activity.

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
                            let updatedActivity = activity
                            updatedActivity.added = true
                            addActivity(updatedActivity)
                        })
                    }
                }
                .navigationTitle("Your Activities")
                .foregroundColor(textColor)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    
  // Adds activities to the list.
    private func addActivity(_ activity: Activity) {
        context.insert(activity)
    }

   // Deletes activities from the list.
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let activity = activities.filter{ $0.added }[index]
            context.delete(activity)
        }
    }
    
}
// Allows you to preview the page. 
#Preview {
    do {
        let previewer = try ActivityPreviewer()

        return ActivityListView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
