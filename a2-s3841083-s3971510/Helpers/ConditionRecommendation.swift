//
//  ConditionReccomendation.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 5/10/2024.
//

import Foundation
import SwiftUI

/// Returns the necessary color for the activity, based on whether the given parameters are within range.
///
/// This function evaluates the current weather conditions against an activity's preferred conditions (temperature, precipitation, humidity, and wind). It returns a color that indicates how suitable the weather is for the activity:
/// - Green: If all conditions are within the preferred range of the activity.
/// - Yellow: If three conditions are within the range.
/// - Red: If one or no conditions are within the range.
///
/// - Parameters:
///   - activity: The `Activity` object representing the user’s added activity, containing preferred ranges for temperature, precipitation, humidity, and wind.
///   - currentTemp: The current temperature retrieved from the OpenWeatherAPI.
///   - currentPrecip: The current precipitation level retrieved from the OpenWeatherAPI.
///   - currentHumidity: The current humidity level retrieved from the OpenWeatherAPI.
///   - currentWind: The current wind speed retrieved from the OpenWeatherAPI.
///
/// - Returns: A `Color` indicating the suitability of the weather for the activity:
///   - Green if all conditions are within the preferred range.
///   - Yellow if three conditions are within the range.
///   - Red if one or no conditions are within the range.
///
/// - Example:
/// ```swift
/// let hikingActivity = Activity(
///     activityId: 1,
///     activityName: "Hiking",
///     humidityRange: [30, 60],
///     temperatureRange: [15.0, 25.0],
///     windRange: [0.0, 10.0],
///     precipRange: [0.0, 5.0],
///     keyword: "Outdoor",
///     added: true,
///     scheduled: false
/// )
///
/// let currentTemperature = 22.0   // Current temperature
/// let currentPrecipitation = 1.0   // Current precipitation
/// let currentHumidity = 45         // Current humidity
/// let currentWindSpeed = 5.0       // Current wind speed
///
/// let resultColor = determineActivityColor(
///     activity: hikingActivity,
///     currentTemp: currentTemperature,
///     currentPrecip: currentPrecipitation,
///     currentHumidity: currentHumidity,
///     currentWind: currentWindSpeed
/// )
///
/// print(resultColor) // Output: .green
///
/// // Example with mixed conditions
/// let resultColor2 = determineActivityColor(
///     activity: hikingActivity,
///     currentTemp: 30.0, // Too hot
///     currentPrecip: 10.0, // Too much rain
///     currentHumidity: 80, // Too humid
///     currentWind: 3.0 // Within range
/// )
///
/// print(resultColor2) // Output: .red
/// ```
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

/// Returns a color by determining whether a condition is within an activity's preferred range.
///
/// This function evaluates whether the current weather condition (e.g., temperature, humidity, wind, or precipitation) falls within an activity's preferred range. It returns a color indicating how well the current condition fits the activity's range:
/// - Green: If the current condition is within the optimal range.
/// - Yellow: If the condition is within a partial range (up to +/- 2.01 units beyond the preferred range).
/// - Red: If the condition falls outside both ranges.
///
/// - Parameters:
///   - conditionRange: A two-element array representing the preferred condition range of the activity (e.g., `[lowerBound, upperBound]`).
///   - currentCondition: The current weather condition (e.g., temperature, precipitation, humidity, wind).
///
/// - Returns: A `Color` indicating whether the condition fits:
///   - Green if the condition is within the optimal range.
///   - Yellow if the condition is within a partial range (within +/- 2.01 units of the range).
///   - Red if it falls outside both ranges.
///
/// - Example:
/// ```swift
/// let temperatureRange = [15.0, 25.0] // Activity's preferred temperature range
/// let currentTemperature = 17.0 // Current temperature
///
/// let resultColor = determineInRange(conditionRange: temperatureRange, currentCondition: currentTemperature)
///
/// print(resultColor) // Output: .green
///
/// let currentTemperature2 = 13.0
/// let resultColor2 = determineInRange(conditionRange: temperatureRange, currentCondition: currentTemperature2)
///
/// print(resultColor2) // Output: .yellow
///
/// let currentTemperature3 = 5.0
/// let resultColor3 = determineInRange(conditionRange: temperatureRange, currentCondition: currentTemperature3)
///
/// print(resultColor3) // Output: .red
/// ```
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

/// Retrieves the weather data for a specific date from the provided weather response.
///
/// This function searches through the daily weather data contained in the `ResponseBody` object to find the weather information that matches the specified date (as a Unix timestamp). If a match is found, it returns the corresponding `DailyWeatherResponse`, otherwise it returns `nil`.
///
/// - Parameters:
///   - date: The Unix timestamp (in seconds) representing the date for which the weather information is required.
///   - data: The weather response data containing daily weather entries, typically retrieved from a weather API.
///
/// - Returns: An optional `ResponseBody.DailyWeatherResponse` object that contains the weather information for the specified date. If no matching weather data is found for the given date, the function returns `nil`.
///
/// - Example:
/// ```swift
/// if let weather = getWeatherForDate(date: targetDate, data: responseBody) {
///     print("Weather for the given date: \(weather)")
/// } else {
///     print("No weather data available for the given date.")
/// }
/// ```
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
///
/// - Example:
/// ```swift
/// let addedActivities = [
///     Activity(activityId: 1, activityName: "Running", humidityRange: [30, 60], temperatureRange: [10.0, 20.0], windRange: [0.0, 5.0], precipRange: [0.0, 0.5], keyword: "outdoor", added: true, scheduled: false),
///     Activity(activityId: 2, activityName: "Cycling", humidityRange: [20, 50], temperatureRange: [15.0, 25.0], windRange: [0.0, 8.0], precipRange: [0.0, 0.3], keyword: "outdoor", added: true, scheduled: false)
/// ]
///
/// let currentTemp = 18.0
/// let currentPrecip = 0.1
/// let currentHumidity = 40
/// let currentWind = 3.0
///
/// let overallConditionColor = getConditionColorForDay(addedActivities: addedActivities, currentTemp: currentTemp, currentPrecip: currentPrecip, currentHumidity: currentHumidity, currentWind: currentWind)
///
/// print(overallConditionColor) // Output: .green
/// ```
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

