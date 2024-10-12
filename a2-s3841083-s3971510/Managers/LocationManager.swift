//
//  LocationManager.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 23/9/2024.
//

import Foundation
import CoreLocation

/// A class responsible for managing location services, retrieving the user's current location,
/// and saving/retrieving location data using UserDefaults.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    /// Initializes the LocationManager and requests permission to use location services.
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization() // Request permission to use location
    }
    
    /// Requests the current location of the user.
    ///
    /// This function sets the loading state to true and initiates the location request.
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
    
    /// Delegate method called when new location data is available.
    ///
    /// - Parameters:
    ///   - manager: The CLLocationManager instance that generated the update.
    ///   - locations: An array of CLLocation objects representing the updated locations.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else {
            isLoading = false
            return
        }
        
        location = newLocation.coordinate
        saveLocation(location: newLocation)
        isLoading = false
    }
    
    /// Delegate method called when location updates fail.
    ///
    /// - Parameters:
    ///   - manager: The CLLocationManager instance that generated the error.
    ///   - error: The error that occurred while trying to obtain location data.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location:", error)
        isLoading = false
    }
    
    /// Saves the current location to UserDefaults.
    ///
    /// - Parameter location: The CLLocation object representing the location to be saved.
    private func saveLocation(location: CLLocation) {
        let locationData: [String: Double] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        UserDefaults.standard.set(locationData, forKey: "savedLocation")
        print("Location saved: \(locationData)")
    }
    
    /// Retrieves the saved location from UserDefaults.
    ///
    /// - Returns: An optional CLLocationCoordinate2D containing the saved location coordinates,
    ///            or nil if no location has been saved.
    func retrieveSavedLocation() -> CLLocationCoordinate2D? {
        if let savedLocation = UserDefaults.standard.dictionary(forKey: "savedLocation") as? [String: Double],
           let latitude = savedLocation["latitude"],
           let longitude = savedLocation["longitude"] {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}


