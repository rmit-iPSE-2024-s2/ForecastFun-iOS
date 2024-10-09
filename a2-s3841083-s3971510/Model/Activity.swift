//
//  Activity.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 29/9/2024.
//

import Foundation
import SwiftData

@Model
class Activity: Identifiable {
    var activityId: Int
    var activityName: String
    var humidityRange: [Int]
    var temperatureRange: [Double]
    var windRange: [Double]
    var precipRange: [Double]
    var keyword: String
    var added: Bool
    var scheduled: Bool
    var temp: Double?
    var humid: Int?
    var wind: Double?
    var precip: Double?
    var start: Int?
    var end: Date?
    var location: String?

    init(
        activityId: Int,
        activityName: String,
        humidityRange: [Int],
        temperatureRange: [Double],
        windRange: [Double],
        precipRange: [Double],
        keyword: String,
        added: Bool,
        scheduled: Bool,
        temp: Double? = nil,
        humid: Int? = nil,
        wind: Double? = nil,
        precip: Double? = nil,
        start: Int? = nil,
        end: Date? = nil,
        location: String? = nil
    ) {
        self.activityId = activityId
        self.activityName = activityName
        self.humidityRange = humidityRange
        self.temperatureRange = temperatureRange
        self.windRange = windRange
        self.precipRange = precipRange
        self.keyword = keyword
        self.added = added
        self.scheduled = scheduled
        self.temp = temp
        self.humid = humid
        self.wind = wind
        self.precip = precip
        self.start = start
        self.end = end
        self.location = location
    }
}
