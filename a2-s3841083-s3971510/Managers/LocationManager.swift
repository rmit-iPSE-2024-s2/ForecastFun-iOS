//
//  LocationManager.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 23/9/2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject{
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D
    @Published var isLoading = false
    
    override init(){
        super.init()
        manager.delegate.self()
    }
    
    func requestLocation(){
        isLoading = true
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocation locations: [CLLocation]){
        locations = locations.first?.coordinate
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error getting location", error)
        isLoading = false
    }

}
