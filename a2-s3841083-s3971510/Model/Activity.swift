//
//  Activity.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 29/9/2024.
//

import Foundation
import SwiftData

@Model
/// The Activity class represents an activity that a user can perform, along with its related weather conditions and scheduling details
class Activity: Identifiable {
    /// The unique identifier for the activity.
    var activityId: Int
    
    /// The name of the activity.
    var activityName: String
    
    /// The range of humidity levels (in percentage) suitable for the activity.
    var humidityRange: [Int]
    
    /// The range of temperature levels (in degrees Celsius) suitable for the activity.
    var temperatureRange: [Double]
    
    /// The range of wind speeds (in meters per second) suitable for the activity.
    var windRange: [Double]
    
    /// The range of precipitation levels (in millimeters) acceptable for the activity.
    var precipRange: [Double]
    
    /// A keyword associated with the activity for search or categorization purposes.
    var keyword: String
    
    /// A boolean indicating whether the activity has been added to the user's favorites or liked activities.
    var added: Bool
    
    /// A boolean indicating whether the activity is scheduled.
    var scheduled: Bool
    
    /// The temperature (in degrees Celsius) for the scheduled activity, if available.
    var temp: Double?
    
    /// The humidity level (in percentage) for the scheduled activity, if available.
    var humid: Int?
    
    /// The wind speed (in meters per second) for the scheduled activity, if available.
    var wind: Double?
    
    /// The precipitation level (in millimeters) for the scheduled activity, if available.
    var precip: Double?
    
    /// The start time for the activity, represented as a timestamp (optional).
    var start: Int?
    
    /// The location where the activity is to be performed, if specified.
    var location: String?
    
    /// A text description of the conditions suitable for the activity, if available.
    var conditionText: String?

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
        location: String? = nil,
        conditionText: String? = nil
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
        self.location = location
        self.conditionText = conditionText
    }
}
