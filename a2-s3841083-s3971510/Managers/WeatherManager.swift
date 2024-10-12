//
//  WeatherManager.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 24/9/2024.
//

import Foundation
import CoreLocation

/// A class responsible for fetching current weather data from the OpenWeather API.
class WeatherManager {
    
    /// Fetches the current weather data for a specific location identified by latitude and longitude.
    ///
    /// This asynchronous function constructs a URL to call the OpenWeather API and fetch current weather data,
    /// excluding unnecessary data like minutely and hourly forecasts, as well as alerts. It decodes the response
    /// into a `ResponseBody` object.
    ///
    /// - Parameters:
    ///   - latitude: The latitude of the location for which the weather data is requested.
    ///   - longitude: The longitude of the location for which the weather data is requested.
    ///
    /// - Returns: A `ResponseBody` object containing the current weather data.
    ///
    /// - Throws: An error if the URL is invalid, if the network request fails, or if the response cannot be decoded.
    ///
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody{
        guard let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly,alerts&appid=393f6d914182e60f72252f09ee2960e3&units=metric")

        else { fatalError("Error: Missing URL") }
        
        let urlRequest = URLRequest(url:url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error: weather data could not be fetched")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from:data)
        
        return decodedData
                
    }
    
    
}

/// Represents the response from the OpenWeather API containing weather information.
///
/// The `ResponseBody` struct conforms to the `Decodable` protocol, allowing it to be
/// decoded from JSON responses returned by the OpenWeather API. It contains details
/// about the current weather and a daily forecast.
struct ResponseBody: Decodable {
    /// The latitude of the location for the weather data.
    var lat: Double
    
    /// The longitude of the location for the weather data.
    var lon: Double
    
    /// The timezone of the location, formatted as a string.
    var timezone: String
    
    /// The timezone offset in seconds from UTC.
    var timezone_offset: Int
    
    /// The current weather information.
    var current: CurrentWeatherResponse
    
    /// An array of daily weather forecasts.
    var daily: [DailyWeatherResponse]

    /// Represents the current weather response details.
    struct CurrentWeatherResponse: Decodable {
        /// The timestamp of the data in UNIX format.
        var dt: Int
        
        /// The current temperature in degrees Celsius.
        var temp: Double
        
        /// The current humidity percentage.
        var humidity: Int
        
        /// The current cloudiness percentage.
        var clouds: Int
        
        /// The current wind speed in meters per second.
        var wind_speed: Double
        
        /// An array of weather conditions.
        var weather: [WeatherResponse]
        
        /// Optional rain information for the current weather.
        var rain: RainResponse?
    }

    /// Represents the daily weather forecast details.
    struct DailyWeatherResponse: Decodable, Hashable {
        /// The timestamp of the daily forecast in UNIX format.
        var dt: Int
        
        /// The temperature details for the day.
        var temp: TempResponse
        
        /// The daily humidity percentage.
        var humidity: Int
        
        /// The wind speed for the day in meters per second.
        var wind_speed: Double
        
        /// An array of weather conditions for the day.
        var weather: [WeatherResponse]
        
        /// The probability of precipitation for the day.
        var pop: Double
        
        /// Optional rain amount for the day.
        var rain: Double?
    }

    /// Represents temperature details.
    struct TempResponse: Decodable, Hashable {
        /// The day temperature in degrees Celsius.
        var day: Double
        
        /// The minimum temperature during the day in degrees Celsius.
        var min: Double
        
        /// The maximum temperature during the day in degrees Celsius.
        var max: Double
    }

    /// Represents weather condition details.
    struct WeatherResponse: Decodable, Hashable {
        /// The unique identifier for the weather condition.
        var id: Int
        
        /// A short description of the weather condition (e.g., "Clear").
        var main: String
        
        /// A more detailed description of the weather condition (e.g., "clear sky").
        var description: String
        
        /// The icon code representing the weather condition.
        var icon: String
    }

    /// Represents rain information for the current weather.
    struct RainResponse: Decodable {
        /// The amount of rain in the last hour, in millimeters.
        var oneHour: Double?
        
        /// Coding keys to map the JSON keys to property names.
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }
}

