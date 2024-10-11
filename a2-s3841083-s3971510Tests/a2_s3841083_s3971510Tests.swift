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
    // The below tests essentially simulates adding an activity to an array of activities. This ensures that when activities are added, they are added
    // correctly. This test is important as it makes sure that when activities are added, they are correctly displayed and do not cause any errors.
    func testAddActivity() {
        
        var activities: [Activity] = []
        let newActivity = Activity(activityId: 1, activityName: "Running", humidityRange: [30, 50], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: false, scheduled: false)
        
        
        activities.append(newActivity)
        
        
        XCTAssertEqual(activities.count, 1)
        XCTAssertEqual(activities.first?.activityName, "Running")
    }
}

// This test essentially simulates when a user deletes an activity from the list after it has been added. This is to make sure that activities are correctly
// removed if the user changes their mind. This is important as it ensures the list is able to be modified to the user's liking.
func testDeleteActivity() {
    
    var activities: [Activity] = [
        Activity(activityId: 1, activityName: "Running", humidityRange: [30, 50], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false)
    ]
    
    
    let activityToDelete = activities[0]
    activities.removeAll { $0.activityId == activityToDelete.activityId }
    
    
    XCTAssertEqual(activities.count, 0)
}
// This test essentially compares the current weather conditions to the defined weather conditions set in the parameters page. This ensures that activities are displayed based on the pre-determined weather conditions only. This is important as it ensures activities do not show up that do not match the pre-determined conditions.
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
// This test essentialls makes sure that when the page is initialized, it displays the correct default values. This ensures the default values are set correctly to average conditions before they are manually changed. This is important as it ensures activities aren't shown in unexpected or unwanted conditions.
func testDefaultActivityValues() {
   
    let activity = Activity(activityId: 1, activityName: "Cycling", humidityRange: [30, 60], temperatureRange: [15, 25], windRange: [0, 10], precipRange: [0, 1], keyword: "outdoor", added: true, scheduled: false)
    
   
    XCTAssertEqual(activity.temperatureRange[0], 15.0)
    XCTAssertEqual(activity.windRange[0], 0.0)
    XCTAssertEqual(activity.precipRange[0], 0.0)
    XCTAssertFalse(activity.scheduled)
}
// This test essentially ensures that activities with the same activityID is not added to the list twice. This ensures duplicates are not included in the list, and is important as it can provide incorrect activities as it could contimate the conditions you are after. 
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
