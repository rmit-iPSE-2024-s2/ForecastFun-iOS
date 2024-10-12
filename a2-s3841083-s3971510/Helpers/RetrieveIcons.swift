//
//  RetrieveIcons.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 12/10/2024.
//

import Foundation

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
