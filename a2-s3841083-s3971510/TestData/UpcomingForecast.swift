//
//  DayScheduleOptions.swift
//  A1
//
//  Created by Francis Z on 31/8/2024.
//

import Foundation

enum UpcomingForecast: Int, CaseIterable{
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    
    
    var title: String{
        switch self{
        case .Monday: return "Mon"
        case .Tuesday: return "Tue"
        case .Wednesday: return "Wed"
        case .Thursday: return "Thu"
            
        }
    }
    
    var scheduledActivties: [ScheduledActivity]{
        switch self {
        case .Monday:
            return mondaySchedule
        case .Tuesday:
            return tuesdaySchedule
        case .Wednesday:
            return wednesdaySchedule
        case .Thursday:
            return thursdaySchedule
        }
    }
    
    var dayForecast: [DayForecast] {
        switch self {
        case .Monday:
            return mondayForecast
        case .Tuesday:
            return tuesdayForecast
        case .Wednesday:
            return wednesdayForecast
        case .Thursday:
            return thursdayForecast
        }
    }
}
