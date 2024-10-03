//
//  ActivityView.swift
//  A1
//
//  Created by Francis Z on 30/8/2024.
//

import SwiftUI
import SwiftData

struct ScheduleView: View {
    @State private var selectedOption: UpcomingForecast = .Monday
    @Environment(\.modelContext) var modelContext
    @Query var activities: [Activity]
    var body: some View {
        ZStack{
            Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0)
                .ignoresSafeArea(.all)
            
            
            VStack(alignment:.center, spacing: 30){
                Text("Scheduled Activities")
                    .font(.title)
                    .foregroundColor(Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0))
                
                // menu options list
                ScheduleOptionList(selectedOption: $selectedOption)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(UpcomingForecast.allCases.filter { $0 == selectedOption }, id: \.self) { day in
                        ScheduleActivitySection(activity: day)
                    }
                }
            }.padding(20)
            
            
                
        }
        .foregroundColor(Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0))
        
    }
}

#Preview {
    do {
        let previewer = try ActivityPreviewer()

        return ScheduleView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
