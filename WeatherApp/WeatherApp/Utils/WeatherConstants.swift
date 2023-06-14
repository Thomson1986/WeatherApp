//
//  WeatherConstants.swift
//  WeatherApp
//
//  Created by Thomson Varghese on 6/13/23.
//

import Foundation
import UIKit

enum ResponseType {
    
    case success(WeatherResponse)
    case error
}

struct WeatherConstants {
    
    static let savedKey = "com.tcs.weatherApp.savedLocation"
    static var apiKey: String {
        return "1a356bf3dd820e488e2172e12e651e6d"
    }
    static var weatherAPIBaseURL: String {
        return "https://api.openweathermap.org/data/2.5/weather"

    }
    static var geoAPIBaseURL: String {
        return "https://api.openweathermap.org/geo/1.0/reverse"
    }
    
    static var imageBaseURL: String {
        return "https://openweathermap.org/img/wn/"
    }
    
    static var getLastSearchedCity: String? {
        return UserDefaults.standard.value(forKey: WeatherConstants.savedKey) as? String
    }
    
    func saveSearchedCity(_ city: String) {
        UserDefaults.standard.setValue(city, forKey: WeatherConstants.savedKey)
    }
}

//TODO - Can add more specific error cases
enum WeatherError: Error {
    case unknownError
    case invalidResponse
}

// MARK: Helper extension to format double to string
extension Double {
    func toString() -> String {
        let result = String(format: "%.1f", self)
        return result.isEmpty ? "--" : result
    }
}

// MARK: Helper extension to download and cache image
extension UIImageView {
    
    func load(url: URL, placeholder: UIImage?) {
       
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        //Fetch from cache
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.image = image
            }
        }
        else {
            //Fetch from url and save in cache
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let response = response, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }.resume()
        }
        
    }
}
