//
//  LocationManager.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 23/9/2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization() // Request permission to use location
    }
    
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else {
            isLoading = false
            return
        }
        
        location = newLocation.coordinate
        saveLocation(location: newLocation)
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location:", error)
        isLoading = false
    }
    
    private func saveLocation(location: CLLocation) {
        let locationData: [String: Double] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        UserDefaults.standard.set(locationData, forKey: "savedLocation")
        print("Location saved: \(locationData)")
    }
    
    func retrieveSavedLocation() -> CLLocationCoordinate2D? {
        if let savedLocation = UserDefaults.standard.dictionary(forKey: "savedLocation") as? [String: Double],
           let latitude = savedLocation["latitude"],
           let longitude = savedLocation["longitude"] {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}


