//
//  HourlyForecastManager.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 28/9/2024.
//

import Foundation
import CoreLocation

class HourlyForecastManager {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody{
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=393f6d914182e60f72252f09ee2960e3&units=metric")
        else { fatalError("Error: Missing URL") }
        
        let urlRequest = URLRequest(url:url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error: 3 hour data could not be fetched")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from:data)
        
        return decodedData
            
                
    }
}
