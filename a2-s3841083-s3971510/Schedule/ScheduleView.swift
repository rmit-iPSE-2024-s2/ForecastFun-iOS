//
//  ActivityView.swift
//  A1
//
//  Created by Francis Z on 30/8/2024.
//

import SwiftUI

struct ScheduleView: View {
    @State private var selectedOption: UpcomingForecast = .Monday
    var body: some View {
        ZStack{
            Color(red: 218/255, green:210/255 , blue: 240/255, opacity: 1.0)
                .ignoresSafeArea(.all)
            
            
            VStack(alignment:.center, spacing: 30){
                Text("Scheduled Activities")
                    .font(.title)
                    .foregroundColor(Color(red: 55/255, green:31/255 , blue: 92/255, opacity: 1.0))
                
                // menu options list
                ScheduleOptionList(selectedOption: $selectedOption)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(UpcomingForecast.allCases.filter { $0 == selectedOption }, id: \.self) { day in
                        ScheduleActivitySection(activity: day)
                    }
                }
            }.padding(20)
            
            
                
        }
        .foregroundColor(Color(red: 55/255, green:31/255 , blue: 92/255, opacity: 1.0))
        
    }
}

#Preview {
    ScheduleView()
}
