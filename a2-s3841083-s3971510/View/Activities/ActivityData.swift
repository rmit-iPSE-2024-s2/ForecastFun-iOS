//
//  ActivityData.swift
//  a2-s3841083-s3971510
//
//  Created by Anthony Forti on 4/10/2024.
//

import SwiftData
import Foundation

@Model
class ActivityRecord: Identifiable {
    @Attribute var activityName: String
    @Attribute var location: String
    @Attribute var day: String
    @Attribute var time: String

    init(activityName: String, location: String, day: String, time: String) {
        self.activityName = activityName
        self.location = location
        self.day = day
        self.time = time
    }
}
