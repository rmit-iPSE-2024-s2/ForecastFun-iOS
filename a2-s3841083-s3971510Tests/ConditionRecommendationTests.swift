//
//  ConditionRecommendationTests.swift
//  a2-s3841083-s3971510Tests
//
//  Created by Francis Z on 11/10/2024.
//

import XCTest
@testable import a2_s3841083_s3971510
import SwiftUI
final class ConditionRecommendationTests: XCTestCase {
    
    func testDetermineInRange() {
        let conditionRange = [0.0,20.0]
        let currentCondition = 10.0
        
        let conditionColor = determineInRange(conditionRange: conditionRange, currentCondition: currentCondition)
        
        XCTAssertEqual(conditionColor, Color.green)
    }
    
    func testDetermineActivityColor(){
        // define activity
        let activity = Activity(activityId: 1, activityName: "Running", humidityRange: [30, 50], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: false, scheduled: false)
        
        // define the weather parameters of a given day
        let currentTemp = 20.0
        let currentPrecip = 2.0
        let currentHumidity = 50
        let currentWind = 15.0
        
        let conditionColor = determineActivityColor(activity: activity, currentTemp: currentTemp, currentPrecip: currentPrecip, currentHumidity: currentHumidity, currentWind: currentWind)
        
        XCTAssertEqual(conditionColor, Color.yellow)
        
    }
    
    func testGetConditionColorForDay(){
        
        // define the weather parameters of a given day
        let currentTemp = 20.0
        let currentPrecip = 2.0
        let currentHumidity = 50
        let currentWind = 15.0
        
        let addedActivities = [
            Activity(activityId: 1, activityName: "Running", humidityRange: [10, 15], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false),
            Activity(activityId: 1, activityName: "Walking", humidityRange: [30, 50], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false)
        ]
        
        let conditionColor = getConditionColorForDay(addedActivities: addedActivities, currentTemp: currentTemp, currentPrecip: currentPrecip, currentHumidity: currentHumidity, currentWind: currentWind)
        
        XCTAssertEqual(conditionColor, Color.red)
    }
    
    
    func testConvertToDayOfWeek() {
            // Unix timestamp for a specific date (October 12, 2024, which is a Saturday)
            let unixTimestamp: Int = 1728681600 // Unix timestamp for 2024-10-12 (Saturday)
            
            let dayOfWeek = unixTimestamp.convertToDayOfWeek()
            
            XCTAssertEqual(dayOfWeek, "Sat", "Expected 'Sat' for the given timestamp")
    }
    
    func testConvertToFullDayOfWeek() {
        // define a unix timestamp
        let unixTimestamp: Int = 1728681600 // Unix timestamp for 2024-10-12 (Saturday)
        
        let fullDayOfWeek = unixTimestamp.convertToFullDayOfWeek()

        XCTAssertEqual(fullDayOfWeek, "Saturday", "Expected 'Saturday' for the given timestamp")
    }
    
    func testDetermineConditionText_FairConditions() {
            // Arrange
            let mockDay = mockDailyWeatherResponse() // Mock weather data
            let mockActivity = Activity(activityId: 1, activityName: "Running", humidityRange: [10, 15], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false)
         
            // Act
            let conditionText = determineConditionText(activity: mockActivity, day: mockDay)
            
            // Assert
            XCTAssertEqual(conditionText, "Fair Conditions", "The condition text should be 'Fair Conditions'")
    }
    
    // MOCK Daily Daily weather response and other required responses
    
    func mockDailyWeatherResponse() -> ResponseBody.DailyWeatherResponse {
        return ResponseBody.DailyWeatherResponse(
            dt: 1697028000,
            sunrise: 1696992000,
            sunset: 1697035200,
            moonrise: 1697000000,
            moonset: 1697050000,
            moon_phase: 0.5,
            summary: "Partly cloudy",
            temp: mockTempResponse(),
            feels_like: mockFeelsLikeResponse(),
            pressure: 1013,
            humidity: 65,
            dew_point: 14.0,
            wind_speed: 5.0,
            wind_deg: 200,
            wind_gust: 8.0,
            weather: [mockWeatherResponse()],
            clouds: 20,
            pop: 0.1,
            rain: 0.2,
            uvi: 5.0
        )
    }
    
    func mockWeatherResponse() -> ResponseBody.WeatherResponse {
        return ResponseBody.WeatherResponse(
            id: 800,
            main: "Clear",
            description: "clear sky",
            icon: "01d"
        )
    }
    
    func mockTempResponse() -> ResponseBody.TempResponse {
        return ResponseBody.TempResponse(
            day: 20.0,
            min: 15.0,
            max: 25.0,
            night: 18.0,
            eve: 22.0,
            morn: 16.0
        )
    }
    
    func mockFeelsLikeResponse() -> ResponseBody.FeelsLikeResponse {
        return ResponseBody.FeelsLikeResponse(
            day: 18.0,
            night: 17.0,
            eve: 20.0,
            morn: 16.0
        )
    }
}
