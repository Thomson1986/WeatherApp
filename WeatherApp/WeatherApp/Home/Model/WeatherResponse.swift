//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Thomson Varghese on 6/13/23.
//

import Foundation

//Model for weather response
struct WeatherResponse: Codable {
    
    let coordinate: Coordinate?
    let weather: [Weather]?
    let main: Main?
    let name: String
    let wind: Wind?
    
    enum CodingKeys: String, CodingKey {
        
        case coordinate = "coord"
        case weather
        case main
        case name
        case wind
    }
}

struct Coordinate: Codable {
    let lat: Double?
    let lon: Double?
}

struct Weather: Codable {
    let description: String?
    let icon: String?
}

struct Main: Codable {
    
    let temperature: Double?
    let feelsLike: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
    }
}

struct Wind: Codable {
    
    let speed: Double?
}
