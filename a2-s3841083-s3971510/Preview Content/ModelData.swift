//
//  ModelData.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 26/9/2024.
//

import Foundation

// Preview weather data, loaded from the JSON file for testing and SwiftUI previews
var previewWeather: ResponseBody = load("weatherData.json")

// Function to load and decode the JSON data into the ResponseBody struct
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    // Check if the file exists in the app bundle
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        // Try loading the data from the file
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        // Decode the data into the expected format
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

// Extension to ResponseBody for calculating precipitation based on the current weather
extension ResponseBody {
    // Property to return the precipitation amount (in mm), based on the current weather
    var precipitation: Double {
        // Check current weather for rain
        if let rainAmount = current.rain?.oneHour {
            return rainAmount
        } else {
            return 0.0 // No chance of rain
        }
    }

    // Property to return daily precipitation amount (in mm)
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
    // Property to return the precipitation amount (in mm), based on the current weather
    var precipitation: Double {
        // Check current weather for rain
        if let rainAmount = rain?.oneHour {
            return rainAmount
        } else {
            return 0.0 // No chance of rain
        }
    }

    // Property to return daily precipitation amount (in mm)

}


extension ResponseBody.DailyWeatherResponse {
    // Property to return the precipitation amount (in mm), based on the current weather
    var dailyPrecipitation: Double {
        if let rainAmount = rain {
            return rainAmount
        } else  {
            return 0.0 // No chance of rain
        }
        
    }
}


