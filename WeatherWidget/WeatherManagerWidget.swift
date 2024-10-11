//
//  WeatherManagerWidget.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 11/10/2024.
//

// Essentially a copy of WeatherManager from the main app.
// Responsible for retrieving API weather from OpenWeather API.
import Foundation
import CoreLocation
import WidgetKit
// Gets current weather based on longitude and latitude.
class WeatherManagerWidget {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> WeatherResponseBody {
        // API Call for weather..
        guard let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly,alerts&appid=393f6d914182e60f72252f09ee2960e3&units=metric")
                // If the API call doesn't work, it will display 'ERROR: Missing URL'.
        else { fatalError("Error: Missing URL") }
        // Awaiting a response from the API using URLRequest.
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        // If response has a code of 200 (OK), then continue. Else, give error message.
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: weather data could not be fetched")
        }
        
        let decodedData = try JSONDecoder().decode(WeatherResponseBody.self, from: data)
        // Returns the decoded weather data from OpenWeather API call.
        return decodedData
    }
}
// Defines the weather structure received from OpenWeather API.
struct WeatherResponseBody: Decodable {
    var lat: Double
    var lon: Double
    var timezone: String
    var timezone_offset: Int
    var current: CurrentWeatherResponse
    var daily: [DailyWeatherResponse]
// Represents current weather conditions.
    struct CurrentWeatherResponse: Decodable {
        var dt: Int
        var sunrise: Int
        var sunset: Int
        var temp: Double
        var feels_like: Double
        var pressure: Int
        var humidity: Int
        var dew_point: Double
        var uvi: Double
        var clouds: Int
        var visibility: Int
        var wind_speed: Double
        var wind_deg: Int
        var wind_gust: Double?
        var weather: [WeatherResponse]
        var rain: RainResponse?
    }
    // Represents daily forecast.
    struct DailyWeatherResponse: Decodable, Hashable {
        var dt: Int
        var sunrise: Int
        var sunset: Int
        var moonrise: Int
        var moonset: Int
        var moon_phase: Double
        var summary: String
        var temp: TempResponse
        var feels_like: FeelsLikeResponse
        var pressure: Int
        var humidity: Int
        var dew_point: Double
        var wind_speed: Double
        var wind_deg: Int
        var wind_gust: Double?
        var weather: [WeatherResponse]
        var clouds: Int
        var pop: Double
        var rain: Double?
        var uvi: Double
    }
    // How the temp feels like at different points of the day.
    struct TempResponse: Decodable, Hashable {
        var day: Double
        var min: Double
        var max: Double
        var night: Double
        var eve: Double
        var morn: Double
    }
    // How the temp is compared to what it feels like.
    struct FeelsLikeResponse: Decodable, Hashable {
        var day: Double
        var night: Double
        var eve: Double
        var morn: Double
    }
    // Represents main weather type and conditions.
    struct WeatherResponse: Decodable, Hashable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
    // Represents rain data.
    struct RainResponse: Decodable {
        var oneHour: Double? // Amount of mm in last hour. 
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }
}
