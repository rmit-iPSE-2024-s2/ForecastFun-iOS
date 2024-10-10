//
//  ConditionReccomendation.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 5/10/2024.
//

import Foundation
import SwiftUI

/// Returns the necessary colour for the activity, based on whether the given parameters are within in range
/// - Parameters:
///   - activity: The given activity that the user had added to their liked activities
///   - currentTemp: the given temperature based off OpenWeatherAPI
///   - currentPrecip: the given temperature based off OpenWeatherAPI
///   - currentHumidity: the given temperature based off OpenWeatherAPI
///   - currentWind: the given temperature based off OpenWeatherAPI
/// - Returns: A color - green if all conditions are within the preferred range of the activity, yellow if 3 conditions are within the range, and red if 1, or no conditions are within the range
func determineActivityColor(activity: Activity, currentTemp: Double, currentPrecip: Double, currentHumidity: Int, currentWind: Double) -> Color {
    // Check if each condition is in range
    let tempInRange = determineInRange(conditionRange: activity.temperatureRange, currentCondition: currentTemp)
    let precipInRange = determineInRange(conditionRange: activity.precipRange, currentCondition: currentPrecip)
    let humidInRange = determineInRange(conditionRange: activity.humidityRange.map { Double($0) }, currentCondition: Double(currentHumidity))
    let windInRange = determineInRange(conditionRange: activity.windRange, currentCondition: currentWind)

    // Count how many conditions are in range
    let conditionsInRange = [tempInRange, precipInRange, humidInRange, windInRange].filter { $0 == .green }.count

    // Determine final color based on the number of conditions in range
    switch conditionsInRange {
    case 4:
        return .green // All conditions in range
    case 3:
        return .yellow // Three conditions in range
    case 2:
        return .yellow // Two conditions in range
    default:
        return .red // One or zero conditions in range
    }
}

/// Returns a color by determining whether a condition is within an activity's preferred range
/// - Parameters:
///   - conditionRange: the preferred condition range of the activity
///   - currentCondition: weather condition (temp, precipitation, humidity, wind)
/// - Returns: returns a color based off whether the condition value sits within the given range, green if it sits perfectly within the range, yellow if it sits +/- 3 of the range, and red if doesn't otherwise
func determineInRange(conditionRange: [Double], currentCondition:Double) -> Color{
    let lowerBound = conditionRange[0]
    let upperBound = conditionRange[1]
    
    let optimalRange = lowerBound...upperBound
    let inOptimalRange = optimalRange.contains(currentCondition)
    // 20.99 19.99
    let partialLowerBound = lowerBound - 2.01
    let partialUpperBound = upperBound + 2.01
    
    let partialRange = partialLowerBound...partialUpperBound
    let isInPartialRange = partialRange.contains(currentCondition)
    
    if inOptimalRange {
        return .green
    }
    else if isInPartialRange{
        return .yellow
    }
    else{
        return .red
    }
}


// create a function that gets the weather of a day, checks if the conditions of the activity for that days weather
// returns green if at least half of the activities have good conditions
// returns yellow if less than half of the activities have good conditions
// returns red if no activities have good conditions

// create navigation where they can add activities
// it will create a variable activity and add scheduled to it with a time (day) for you to do it
// you can add a location or you can skip
// and then previews what you added


func getWeatherForDate(date: Int, data: ResponseBody) -> ResponseBody.DailyWeatherResponse? {
    // Check if the date matches the current weather
    // Check if the date matches any daily weather entries
    for dailyEntry in data.daily {
        if dailyEntry.dt == date {
            return dailyEntry
        }
    }
    
    // Return nil if no matching weather found
    return nil
}



/// Determines the overall color based condition for the day, based on its weather parameters and the ideal conditions of the users' added activities'
///
/// This function evaluates all the added activities against the current weather conditions (temperature, precipitation, humidity, and wind).
/// Each activity is assigned a condition color (green, yellow, or red) based on how well the weather matches its preferred range.
/// The function then returns an overall color depending on the number of activities that are in "good" condition (green):
/// - If more than half of the activities are in good condition, the function returns green.
/// - If none of the activities are in good condition, it returns red.
/// - Otherwise, it returns yellow.
///
/// - Parameters:
///   - addedActivities: An array of `Activity` objects that represent the activities the user has added.
///   - currentTemp: The current temperature to evaluate against the activities' temperature range.
///   - currentPrecip: The current precipitation level to evaluate against the activities' precipitation range.
///   - currentHumidity: The current humidity level to evaluate against the activities' humidity range.
///   - currentWind: The current wind speed to evaluate against the activities' wind range.
/// - Returns: A `Color` representing the overall condition:
///   - Green if more than half of the activities are in good condition.
///   - Yellow if some are in good condition, but not the majority.
///   - Red if none of the activities are in good condition.

func getConditionColorForDay(addedActivities: [Activity], currentTemp: Double, currentPrecip: Double, currentHumidity: Int, currentWind: Double) -> Color {
    
    // Initialize the array of Colors
    var activityConditions: [Color] = []
    
    // Iterate through all added activities and determine its condition color under the passed weather parameters
    for activity in addedActivities {
        let activityColor = determineActivityColor(activity: activity,
                                                   currentTemp: currentTemp,
                                                   currentPrecip: currentPrecip,
                                                   currentHumidity: currentHumidity,
                                                   currentWind: currentWind)
        // Add the color (condition) to the array
        activityConditions.append(activityColor)
    }
    
    // Count the number of green (good) conditions
    let greenCount = activityConditions.filter { $0 == .green }.count
    let yellowCount = activityConditions.filter { $0 == .yellow }.count
    
    // If more than half of the activities are green, return green
    if greenCount > addedActivities.count / 2 {
        return .green
    }
    else if yellowCount > addedActivities.count / 2 { // If more than half of the activities are yellow, return yellow
        return .yellow
    }
    
    // otherwise return red
    return .red

}
