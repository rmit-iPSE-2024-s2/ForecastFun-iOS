//
//  AddActivityView.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 8/10/2024.
//

import Foundation
import SwiftUI

struct AddActivityView: View {
    let onAdd: (Activity) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedActivity: Activity?
    
    let availableActivities: [Activity] = [
        Activity(activityId: 1, activityName: "Walking", humidityRange: [30, 40], temperatureRange: [18, 25], windRange: [2, 5], precipRange: [0, 0], keyword: "outdoor", added: false, scheduled: false),
        Activity(activityId: 2, activityName: "Running", humidityRange: [30], temperatureRange: [18, 23], windRange: [2], precipRange: [0], keyword: "outdoor", added: false, scheduled: false)
    ]
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let cardBackgroundColor = Color(red: 36/255, green: 50/255, blue: 71/255)
    let highlightColor = Color.blue
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                Text("Add an Activity")
                    .font(.title)
                    .foregroundColor(textColor)
                    .padding()
                
                ForEach(availableActivities, id: \.activityId) { activity in
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

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(onAdd: { _ in })
    }
}
