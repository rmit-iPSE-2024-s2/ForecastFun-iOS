//
//  Extensions.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 26/9/2024.
//

import Foundation

extension Double{
    func roundDouble() -> String{
        return String(format: "%.0f", self)
    }
}


extension Int {
    /// Converts the convert the dt (timestamp) given by OpenWeather API to a readable day of the week
    ///
    ///
    /// - Returns: Returns a string value of the day of the week
    func convertToDayOfWeek() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"  // shortens day name from monday - mon
        return dateFormatter.string(from: date)
    }
}
