//
//  YelpManager.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 9/10/2024.
//

import Foundation
import CoreLocation

/// A class responsible for interacting with the Yelp API to fetch nearby activity locations based on user coordinates.
class YelpManager {
    
    //    let apiKey = "yp0v9lT-IztPk-Syguj6gAyBNYb2bmPXf-qVg_4JECV3UIuzHSU9PQthTL2GgAnu1BM-KTIACxSdGdzSmAwK3F2C_ACzvivHOmDm0C_f2ssA-Io46OGY3cvpjIEGZ3Yx"
    let apiKey = "kVl3Bblf5CYU8lKHhDdDRX_AVJLCsX5Y708B6aZbQnOzF4ikXx2x-XDY4e6iaPyq763up-pTIqA5wTbaO63uRpcO40ncJS0pJQWEIeH5UYH1vdPFGszNbZjWzdIHZ3Yx"
    
    /// Fetches nearby activity locations from Yelp based on the specified latitude, longitude, and activity term.
    ///
    /// This asynchronous function constructs a URL to call the Yelp API's businesses search endpoint. It passes the user's latitude, longitude, desired activity term, and other parameters to retrieve a list of nearby businesses.
    ///
    /// - Parameters:
    ///   - latitude: The latitude of the location for which nearby activity locations are requested.
    ///   - longitude: The longitude of the location for which nearby activity locations are requested.
    ///   - activity: A string representing the activity term to search for (e.g., "running", "yoga").
    ///
    /// - Returns: A `YelpResponse` object containing the list of nearby activity locations.
    ///
    /// - Throws: An error if the network request fails or if the response cannot be decoded.
    ///
    /// - Example:
    /// ```swift
    /// let yelpManager = YelpManager()
    /// do {
    ///     let nearbyActivities = try await yelpManager.getNearbyActivityLocations(latitude: 37.7749, longitude: -122.4194, activity: "running")
    ///     print(nearbyActivities)
    /// } catch {
    ///     print("Failed to fetch nearby activity locations: \(error)")
    /// }
    /// ```
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



/// Represents the response from the Yelp API containing business information.
///
/// The `YelpResponse` struct conforms to the `Decodable` protocol, allowing it to be
/// decoded from JSON responses returned by the Yelp API. It contains an array of
/// businesses that provide details about various establishments.
struct YelpResponse: Decodable {
    /// An array of businesses returned in the response.
    let businesses: [Business]
    
    /// Represents a business in the Yelp API response.
    struct Business: Decodable {
        /// The unique identifier for the business.
        let id: String
        
        /// The name of the business.
        let name: String
        
        /// The average rating of the business, from 1 to 5.
        let rating: Double
        
        /// The total number of reviews for the business.
        let review_count: Int
        
        /// The distance from the search location in meters.
        let distance: Double
        
        /// The location details of the business.
        let location: Location
        
        /// The geographical coordinates of the business.
        let coordinates: Coordinates
        
        /// The URL for the business's page on Yelp.
        let url: String
        
        /// An optional URL for an image of the business.
        let image_url: String?
        
        /// Represents the location details of a business.
        struct Location: Decodable {
            /// The first line of the business's address.
            let address1: String
            
            /// The city where the business is located.
            let city: String
            
            /// The state where the business is located.
            let state: String
            
            /// The ZIP code of the business's location.
            let zip_code: String
        }
        
        /// Represents the geographical coordinates of a business.
        struct Coordinates: Decodable {
            /// The latitude of the business's location.
            let latitude: Double
            
            /// The longitude of the business's location.
            let longitude: Double
        }
        
        /// Represents the category of a business.
        struct Category: Decodable {
            /// The title of the category (e.g., "Restaurant").
            let title: String
        }
    }
}
