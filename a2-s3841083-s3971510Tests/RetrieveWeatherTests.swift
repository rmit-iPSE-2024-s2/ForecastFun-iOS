//
//  RetrieveWeatherTests.swift
//  a2-s3841083-s3971510Tests
//
//  Created by Francis Z on 12/10/2024.
//

import XCTest
@testable import a2_s3841083_s3971510
final class RetrieveWeatherTests: XCTestCase {

    // MOCK FOR WEATHER RESPONSE
    
    func mockResponseBody() -> ResponseBody {
        return ResponseBody(
            lat: -37.8136,
            lon: 144.9631,
            timezone: "Australia/Melbourne",
            timezone_offset: 36000,
            current: mockCurrentWeatherResponse(),
            daily: [mockDailyWeatherResponse()]
        )
    }

    func mockCurrentWeatherResponse() -> ResponseBody.CurrentWeatherResponse {
        return ResponseBody.CurrentWeatherResponse(
            dt: 1697028000,
            temp: 20.0,
            humidity: 65,
            clouds: 20,
            wind_speed: 5.0,
            weather: [mockWeatherResponse()],
            rain: mockRainResponse()
        )
    }

    func mockDailyWeatherResponse() -> ResponseBody.DailyWeatherResponse {
        return ResponseBody.DailyWeatherResponse(
            dt: 1697028000,
            temp: mockTempResponse(),
            humidity: 65,
            wind_speed: 5.0,
            weather: [mockWeatherResponse()],
            pop: 0.1,
            rain: 0.2
        )
    }

    func mockTempResponse() -> ResponseBody.TempResponse {
        return ResponseBody.TempResponse(
            day: 20.0,
            min: 15.0,
            max: 25.0
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

    func mockRainResponse() -> ResponseBody.RainResponse {
        return ResponseBody.RainResponse(oneHour: 0.1)
    }
    
    
    func testGetWeatherForDate_DateNotFound() {
        let date = 1728681600
        let data = mockResponseBody()
        
        let dailyResponse: ResponseBody.DailyWeatherResponse? = getWeatherForDate(date: date, data: data)

        
        XCTAssertNil(dailyResponse, "Date not within response")
    }
    
    func testGetWeatherForDate_DateFound() {
        let date = 1697028000
        let data = mockResponseBody()
        
        let dailyResponse: ResponseBody.DailyWeatherResponse? = getWeatherForDate(date: date, data: data)

        XCTAssertEqual(dailyResponse, mockDailyWeatherResponse())
    }
    
    

}
