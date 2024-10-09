//
//  AddActivityView.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 8/10/2024.
//

import SwiftUI
import SwiftData
struct AddActivityView: View {
    let onAdd: (Activity) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedActivity: Activity?
    @Query var activities: [Activity]
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let cardBackgroundColor = Color(red: 36/255, green: 50/255, blue: 71/255)
    let highlightColor = Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.7)
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                Text("Add an Activity")
                    .font(.title)
                    .foregroundColor(textColor)
                    .padding()
                
                ForEach(activities.filter { !$0.added && !$0.scheduled }, id: \.activityId) { activity in
                    Button(action: {
                        selectedActivity = activity
                    }) {
                        Text(activity.activityName)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedActivity == activity ? highlightColor : cardBackgroundColor)
                            .foregroundColor(textColor)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .sheet(item: $selectedActivity) { activity in
                        SetParametersView(activity: activity, onSave: { updatedActivity in
                            onAdd(updatedActivity)
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                }

                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(highlightColor)
                }
            }
        }
    }
}


#Preview {
    do {
        let previewer = try ActivityPreviewer()

        return AddActivityView(onAdd: { _ in })
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
