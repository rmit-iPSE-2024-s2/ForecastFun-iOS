//
//  RetrieveIcons.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 12/10/2024.
//

import Foundation

/// Returns the corresponding icon name for the given weather condition code.
///
/// This function maps the OpenWeather API's weather condition codes to user-friendly icon names. It provides an appropriate icon representation based on the provided weather icon code.
///
/// - Parameters:
///   - icon: A `String` representing the weather condition code returned by the OpenWeather API (e.g., "01d", "02n").
///
/// - Returns: A `String` representing the user-friendly icon name corresponding to the provided weather condition code:
///   - "clear-day" for clear weather during the day.
///   - "clear-night" for clear weather at night.
///   - "cloudy" for cloudy weather conditions.
///   - "partly-cloudy-night" for partly cloudy weather at night.
///   - "showers" for rain showers during the day and night.
///   - "thunderstorm-showers" for thunderstorms.
///   - "snow" for snowy weather conditions.
///   - "fog" for foggy weather conditions.
///
/// - Example:
/// ```swift
/// let dayIcon = getIconName(from: "01d") // Output: "clear-day"
/// let nightIcon = getIconName(from: "01n") // Output: "clear-night"
/// let cloudyIcon = getIconName(from: "03d") // Output: "cloudy"
/// let snowIcon = getIconName(from: "13n") // Output: "snow"
/// let defaultIcon = getIconName(from: "unknown") // Output: "cloudy"
/// ```
func getIconName(from icon: String) -> String {
    switch icon {
    case "01d":
        return "clear-day"
    case "01n":
        return "clear-night"
    case "02d", "03d", "04d":
        return "cloudy"
    case "02n", "03n", "04n":
        return "partly-cloudy-night"
    case "09d", "10d":
        return "showers"
    case "09n", "10n":
        return "showers"
    case "11d", "11n":
        return "thunderstorm-showers"
    case "13d", "13n":
        return "snow"
    case "50d", "50n":
        return "fog"
    default:
        return "cloudy"
    }
}

/// Returns the corresponding weather icon name for the given weather condition ID.
///
/// This function maps OpenWeather API's weather condition IDs to appropriate icon names. It provides a representation of the weather conditions based on the provided weather ID.
///
/// - Parameters:
///   - weatherID: An `Int` representing the weather condition ID returned by the OpenWeather API (e.g., 200, 300).
///
/// - Returns: A `String` representing the system icon name corresponding to the provided weather condition ID:
///   - "cloud.bolt.rain.fill" for thunderstorms (IDs 200-232).
///   - "cloud.drizzle.fill" for drizzle (IDs 300-321).
///   - "cloud.rain.fill" for rain (IDs 500-531).
///   - "snowflake" for snow (IDs 600-622).
///   - "cloud.fog.fill" for atmospheric conditions such as fog or haze (IDs 701-781).
///   - "sun.max.fill" for clear weather (ID 800).
///   - "cloud.fill" for cloudy conditions (IDs 801-804).
///   - "questionmark" for unknown weather condition IDs.
///
/// - Example:
/// ```swift
/// let thunderstormIcon = getWeatherIcon(for: 200) // Output: "cloud.bolt.rain.fill"
/// let drizzleIcon = getWeatherIcon(for: 300) // Output: "cloud.drizzle.fill"
/// let rainIcon = getWeatherIcon(for: 501) // Output: "cloud.rain.fill"
/// let snowIcon = getWeatherIcon(for: 601) // Output: "snowflake"
/// let fogIcon = getWeatherIcon(for: 701) // Output: "cloud.fog.fill"
/// let clearIcon = getWeatherIcon(for: 800) // Output: "sun.max.fill"
/// let unknownIcon = getWeatherIcon(for: 999) // Output: "questionmark"
/// ```
func getWeatherIcon(for weatherID: Int) -> String {
    switch weatherID {
    case 200...232: // Thunderstorm
        return "cloud.bolt.rain.fill"
    case 300...321: // Drizzle
        return "cloud.drizzle.fill"
    case 500...531: // Rain
        return "cloud.rain.fill"
    case 600...622: // Snow
        return "snowflake"
    case 701...781: // Atmosphere (fog, haze, etc.)
        return "cloud.fog.fill"
    case 800:       // Clear
        return "sun.max.fill"
    case 801...804: // Clouds
        return "cloud.fill"
    default:        // Unknown case
        return "questionmark"
    }
}

/// Determines the condition text for a given activity based on the weather conditions for a specific day.
///
/// This function evaluates the current weather conditions (such as temperature, precipitation, humidity, and wind speed) for a given day and compares them to the acceptable ranges for the specified activity. It returns a textual description of the conditions as "Good Conditions," "Fair Conditions," or "Poor Conditions" based on how well the weather aligns with the activity's ideal conditions.
///
/// - Parameters:
///   - activity: The `Activity` object representing the activity to be performed. It contains acceptable ranges for temperature, precipitation, humidity, and wind speed.
///   - day: A `ResponseBody.DailyWeatherResponse` object that holds the weather data for the specified day, including temperature, precipitation, humidity, and wind speed.
///
/// - Returns: A `String` that describes the condition for the activity as one of the following:
///   - `"Good Conditions"`: All weather conditions fall within the activity's ideal range.
///   - `"Fair Conditions"`: Some of the weather conditions fall outside the activity's ideal range.
///   - `"Poor Conditions"`: Most or all of the weather conditions fall outside the activity's ideal range.
///
/// - Example:
/// ```swift
/// let activity = Activity(
///     activityId: 1,
///     activityName: "Hiking",
///     humidityRange: [30, 60],
///     temperatureRange: [15.0, 25.0],
///     windRange: [0.0, 5.0],
///     precipRange: [0.0, 1.0],
///     keyword: "outdoors",
///     added: true,
///     scheduled: false
/// )
///
/// let dailyWeather = ResponseBody.DailyWeatherResponse(
///     temp: ResponseBody.Temp(day: 20.0),
///     dailyPrecipitation: 0.5,
///     humidity: 50,
///     wind_speed: 3.0
/// )
///
/// let conditionText = determineConditionText(activity: activity, day: dailyWeather)
/// print(conditionText) // Output: "Good Conditions"
/// ```
func determineConditionText(activity: Activity, day: ResponseBody.DailyWeatherResponse) -> String {
    let activityColor = determineActivityColor(
        activity: activity,
        currentTemp: day.temp.day,
        currentPrecip: day.dailyPrecipitation,
        currentHumidity: day.humidity,
        currentWind: day.wind_speed
    )
    
    if activityColor == .green {
        return "Good Conditions"
    } else if activityColor == .yellow {
        return "Fair Conditions"
    } else {
        return "Poor Conditions"
    }
}
