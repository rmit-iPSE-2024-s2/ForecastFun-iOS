//
//  ScheduleActivitySection.swift
//  A1
//
//  Created by Francis Z on 31/8/2024.
//

import SwiftUI

//enum Status {
//    case good, moderate, bad
//}


struct ScheduleActivitySection: View {
    let activity: UpcomingForecast
    
//    let condition: String
    
//    var color: Color {
//            switch condition.lowercased() {
//            case "good":
//                return .green
//            case "moderate":
//                return .yellow
//            case "bad":
//                return .red
//            default:
//                return .gray
//            }
//        }
    
    var body: some View {
        if(activity.scheduledActivties.isEmpty){
            Text("No Activities Scheduled for \(activity)")
        }
        else{
            ForEach(activity.scheduledActivties){activity in
                HStack(){
                    
                    VStack(alignment: .leading, spacing:9){
                        HStack{
                            Text(activity.title)
                            ZStack{
                                Circle()
                                    .frame(width: 14, height:14)
                                    .foregroundColor(.white)
                                Circle()
                                    .frame(width: 10, height:10)
                                    .foregroundColor(.green)
                                    // change to condition/color later
                            }
                            
                        }
                        
                        Text("Time: \(activity.time)")
                        Text("Location: \(activity.location)")
                    }
                    Spacer()
                    
                    
                    
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)

                }
                .foregroundColor(Color(red: 55/255, green: 31/255 , blue: 92/255, opacity: 1.0))
                .padding(.bottom, 10)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(red: 55/255, green: 31/255 , blue: 92/255, opacity: 1.0)),
                    alignment: .bottom
                )
            }
        }
        
        
    }
}

#Preview {
    ScheduleActivitySection(activity: .Monday)
}
