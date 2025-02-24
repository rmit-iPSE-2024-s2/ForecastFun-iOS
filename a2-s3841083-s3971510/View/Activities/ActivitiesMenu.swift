//
//  ActivitiesMenu.swift
//  A1
//
//  Created by Anthony Forti on 30/8/2024.
//

import SwiftData
import SwiftUI

struct ActivitiesMenu: View {
    @Environment(\.modelContext) var modelContext
    @Query var activities: [Activity]
    
    let images = ["Walking",
                  "running",
                  "Swimming",
                  "Cycling",
                  "Basketball"]

    
    var body: some View {
        ZStack {Color(red: 218/255, green:210/255 , blue: 240/255, opacity: 1.0)
                .ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                
                ForEach(activities.filter { !$0.added }) { activity in
                    VStack(alignment: .leading) {
                        Text("Activity ID: \(activity.activityId)")
                        Text("Activity Name: \(activity.activityName)")
                        Text("Added: \(activity.added ? "Yes" : "No")")
                    }
                }
                
                Text("Your Activities")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding()
                ScrollView (.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(images, id: \.self) { image in
                            VStack {
                                Image(image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 140)
                                    .clipped()
                                
                                HStack {
                                    VStack (alignment: .leading){
                                        Text("Walking")
                                            .font(.system(size:14))
                                            .fontWeight(.semibold)
                                        Text("Next optimal time is 8PM")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                        Text("Preffered Conditions →")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("24°")
                                        .font(.caption2)
                                        .padding(6)
                                        .background(Color(.systemGray5))
                                        .clipShape(Circle())
                                    Text("30%")
                                        .font(.caption2)
                                        .padding(6)
                                        .background(Color(.systemGray5))
                                        .clipShape(Circle())
                                    Text("2km")
                                        .font(.caption2)
                                        .padding(6)
                                        .background(Color(.systemGray5))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    
}

#Preview {
    do {
        let previewer = try ActivityPreviewer()

        return ActivitiesMenu()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
