//
//  a2_s3841083_s3971510Tests.swift
//  a2-s3841083-s3971510Tests
//
//  Created by Anthony Forti on 11/10/2024.
//

// Tests for Activities Page

import XCTest
@testable import a2_s3841083_s3971510

final class ActivityTests: XCTestCase {

    func testAddActivity() {
        
        var activities: [Activity] = []
        let newActivity = Activity(activityId: 1, activityName: "Running", humidityRange: [30, 50], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: false, scheduled: false)
        
        
        activities.append(newActivity)
        
        
        XCTAssertEqual(activities.count, 1)
        XCTAssertEqual(activities.first?.activityName, "Running")
    }
}

func testDeleteActivity() {
    
    var activities: [Activity] = [
        Activity(activityId: 1, activityName: "Running", humidityRange: [30, 50], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false)
    ]
    
    
    let activityToDelete = activities[0]
    activities.removeAll { $0.activityId == activityToDelete.activityId }
    
    
    XCTAssertEqual(activities.count, 0)
}

func testMatchingActivityConditions() {
    
    let weather = ResponseBody(
        lat: -37.8136,
        lon: 144.9631,
        timezone: "Australia/Melbourne",
        timezone_offset: 36000,
        current: ResponseBody.CurrentWeatherResponse(
            dt: 1633059073,
            sunrise: 1633027401,
            sunset: 1633072491,
            temp: 20.0,
            feels_like: 19.0,
            pressure: 1012,
            humidity: 60,
            dew_point: 12.0,
            uvi: 0.0,
            clouds: 40,
            visibility: 10000,
            wind_speed: 5.0,
            wind_deg: 210,
            wind_gust: nil,
            weather: [ResponseBody.WeatherResponse(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
            rain: nil
        ),
        daily: []
    )
    
    let activity = Activity(activityId: 1, activityName: "Running", humidityRange: [30, 70], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false)
    
    
    let matchesTemp = weather.current.temp >= activity.temperatureRange[0] && weather.current.temp <= activity.temperatureRange[1]
    let matchesWind = weather.current.wind_speed >= activity.windRange[0] && weather.current.wind_speed <= activity.windRange[1]
    
    
    XCTAssertTrue(matchesTemp)
    XCTAssertTrue(matchesWind)
}

func testDefaultActivityValues() {
   
    let activity = Activity(activityId: 1, activityName: "Cycling", humidityRange: [30, 60], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false)
    
   
    XCTAssertEqual(activity.temperatureRange[0], 15.0)
    XCTAssertEqual(activity.windRange[0], 0.0)
    XCTAssertEqual(activity.precipRange[0], 0.0)
    XCTAssertFalse(activity.scheduled)
}

func testPreventDuplicateActivity() {
    
    var activities: [Activity] = [
        Activity(activityId: 1, activityName: "Running", humidityRange: [30, 50], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false)
    ]
    
    let duplicateActivity = Activity(activityId: 1, activityName: "Running", humidityRange: [30, 50], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false)
    
    
    if !activities.contains(where: { $0.activityId == duplicateActivity.activityId }) {
        activities.append(duplicateActivity)
    }
    
    
    XCTAssertEqual(activities.count, 1)
}
