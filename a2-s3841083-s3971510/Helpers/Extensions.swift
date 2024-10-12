//
//  Extensions.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 26/9/2024.
//

import Foundation
import CoreLocation

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
    
    func convertToFullDayOfWeek() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}

extension UserDefaults {
    func savedLocation() -> CLLocationCoordinate2D? {
            let latitude = double(forKey: "userLatitude")
            let longitude = double(forKey: "userLongitude")
            
            guard latitude != 0.0 || longitude != 0.0 else { return nil }
            
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func saveLocation(latitude: Double, longitude: Double) {
            set(latitude, forKey: "userLatitude")
            set(longitude, forKey: "userLongitude")
    }
}
