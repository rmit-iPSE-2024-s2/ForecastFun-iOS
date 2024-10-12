//
//  Extensions.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 26/9/2024.
//

import Foundation
import CoreLocation

extension Double{
    func roundDouble() -> String{
        return String(format: "%.0f", self)
    }
}


extension Int {
    /// Converts the convert the dt (timestamp) given by OpenWeather API to a shortened readable day of the week
    ///
    ///
    /// - Returns: Returns a string value of the shortened day of the week
    func convertToDayOfWeek() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"  // shortens day name from monday - mon
        return dateFormatter.string(from: date)
    }
    
    /// Converts the convert the dt (timestamp) given by OpenWeather API to a full readable day of the week
    ///
    ///
    /// - Returns: Returns a string value of the full day of the week
    func convertToFullDayOfWeek() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}

extension UserDefaults {
    
    /// Retrieves the saved user location from user defaults.
    ///
    /// This function attempts to fetch the saved latitude and longitude from user defaults.
    /// If both values are zero, it returns `nil`, indicating that no valid location is saved.
    ///
    /// - Returns: An optional `CLLocationCoordinate2D` containing the saved latitude and longitude,
    ///            or `nil` if no valid location exists.
    func savedLocation() -> CLLocationCoordinate2D? {
            let latitude = double(forKey: "userLatitude")
            let longitude = double(forKey: "userLongitude")
            
            guard latitude != 0.0 || longitude != 0.0 else { return nil }
            
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Saves the user's location to user defaults.
    ///
    /// This function stores the provided latitude and longitude values in user defaults
    /// using the keys "userLatitude" and "userLongitude".
    ///
    /// - Parameters:
    ///   - latitude: A `Double` representing the latitude of the user's location.
    ///   - longitude: A `Double` representing the longitude of the user's location.
    func saveLocation(latitude: Double, longitude: Double) {
            set(latitude, forKey: "userLatitude")
            set(longitude, forKey: "userLongitude")
    }
}

// Extension to ResponseBody for calculating precipitation based on the current weather
extension ResponseBody {

    /// Property to return the precipitation amount (in mm), based on the current weather
    var precipitation: Double {
        // Check current weather for rain
        if let rainAmount = current.rain?.oneHour {
            return rainAmount
        } else {
            return 0.0 // No chance of rain
        }
    }

    /// Property to return daily precipitation amount (in mm)
    var dailyPrecipitation: Double {
        // Assuming daily is an array of daily weather data
        var totalPrecipitation: Double = 0.0
        for dailyEntry in daily {
            if let rainAmount = dailyEntry.rain {
                totalPrecipitation += rainAmount
            } else  {
                totalPrecipitation += 0.0 // No chance of rain
            }
        }
        return totalPrecipitation
    }
}

extension ResponseBody.CurrentWeatherResponse {
    /// Property to return the precipitation amount (in mm), based on the current weather
    var precipitation: Double {
        // Check current weather for rain
        if let rainAmount = rain?.oneHour {
            return rainAmount
        } else {
            return 0.0 // No chance of rain
        }
    }

}


extension ResponseBody.DailyWeatherResponse {
    /// Property to return the precipitation amount (in mm), based on the current weather
    var dailyPrecipitation: Double {
        if let rainAmount = rain {
            return rainAmount
        } else  {
            return 0.0 // No chance of rain
        }
        
    }
}
