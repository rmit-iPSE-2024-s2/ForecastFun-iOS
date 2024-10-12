//
//  ModelData.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 26/9/2024.
//

import Foundation

/// Preview weather data, loaded from the JSON file for testing and SwiftUI previews
var previewWeather: ResponseBody = load("weatherData.json")

/// Loads and decodes example weather JSON data for preview from a specified file into a `Decodable` type.
///
/// This generic function attempts to locate a file in the app's main bundle, load its contents as `Data`,
/// and then decode it into the specified type `T`, which must conform to the `Decodable` protocol.
///
/// - Parameter filename: The name of the JSON file to be loaded (including extension).
/// - Returns: An instance of the specified type `T`, populated with the decoded data from the JSON file.
/// - Throws: An error if the file cannot be found, cannot be loaded, or if the data cannot be decoded into the expected type.
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    // Check if the file exists in the app bundle
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        // Try loading the data from the file
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        // Decode the data into the expected format
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}



