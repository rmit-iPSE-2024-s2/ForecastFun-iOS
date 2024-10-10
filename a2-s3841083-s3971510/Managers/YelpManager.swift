//
//  YelpManager.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 9/10/2024.
//

import Foundation
import CoreLocation

class YelpManager {
    
//    let apiKey = "yp0v9lT-IztPk-Syguj6gAyBNYb2bmPXf-qVg_4JECV3UIuzHSU9PQthTL2GgAnu1BM-KTIACxSdGdzSmAwK3F2C_ACzvivHOmDm0C_f2ssA-Io46OGY3cvpjIEGZ3Yx"
    let apiKey = "kVl3Bblf5CYU8lKHhDdDRX_AVJLCsX5Y708B6aZbQnOzF4ikXx2x-XDY4e6iaPyq763up-pTIqA5wTbaO63uRpcO40ncJS0pJQWEIeH5UYH1vdPFGszNbZjWzdIHZ3Yx"
    func getNearbyActivityLocations(latitude: CLLocationDegrees, longitude: CLLocationDegrees, activity: String) async throws -> YelpResponse {
       let url = URL(string: "https://api.yelp.com/v3/businesses/search")!
       var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
       
       let queryItems: [URLQueryItem] = [
           URLQueryItem(name: "latitude", value: "\(latitude)"),
           URLQueryItem(name: "longitude", value: "\(longitude)"),
           URLQueryItem(name: "term", value: activity),
           URLQueryItem(name: "radius", value: "40000"),
           URLQueryItem(name: "sort_by", value: "best_match"),
           URLQueryItem(name: "limit", value: "12")
                     
       ]
       
       components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
       var urlRequest = URLRequest(url: components.url!)
       urlRequest.httpMethod = "GET"
       urlRequest.timeoutInterval = 10
       urlRequest.allHTTPHeaderFields = [
           "Authorization": "Bearer \(apiKey)",
           "accept": "application/json"
       ]

       let (data, _) = try await URLSession.shared.data(for: urlRequest)
       // Decode the JSON response
       let decodedResponse = try JSONDecoder().decode(YelpResponse.self, from: data)
       return decodedResponse
   }
}



struct YelpResponse: Decodable {
    let businesses: [Business]
    
    struct Business: Decodable {
        let id: String
        let name: String
        let rating: Double
        let review_count: Int
        let distance: Double
        let location: Location
        let coordinates: Coordinates
        let url: String
        let image_url: String?
        
        struct Location: Decodable {
            let address1: String
            let city: String
            let state: String
            let zip_code: String
        }
        
        struct Coordinates: Decodable {
            let latitude: Double
            let longitude: Double
        }
        
        struct Category: Decodable {
            let title: String
        }
    }
}
