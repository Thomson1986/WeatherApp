//
//  CityResponse.swift
//  WeatherApp
//
//  Created by Thomson Varghese on 6/13/23.
//

import Foundation

//City model
struct CityResponse: Codable {
    
    let name: String?
    let latitude: Double?
    let longitude: Double?
    let country: String?
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
        case country
        case state
    }
}
