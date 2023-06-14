//
//  WeatherTestUtils.swift
//  WeatherAppTests
//
//  Created by Thomson Varghese on 6/14/23.
//

import Foundation

@testable import WeatherApp

//Utils class to
//1.Read mock response
final class WeatherTestUtils {
    
    //Helper function to  read file from bundle
    static func readJsonData(fromFile fileName: String) -> Data? {
        let resourceName = fileName.components(separatedBy: ".").first
        let fileType = fileName.components(separatedBy: ".").last
        do {
            if let filePath = Bundle.main.path(forResource: resourceName, ofType: fileType) {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        }
        catch {
            return nil
        }
        return nil
    }
    
    //Function to get mocked weather response
    static func readWeatherDetails() -> WeatherResponse? {
        
        guard let response = WeatherTestUtils.readJsonData(fromFile: "MockWeatherResponse.json"),
              let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: response) else {
            return nil
        }
        return weatherResponse
    }
    
    //Function to get mocked city response
    static func readCityDetails() -> [CityResponse]? {
        
        guard let response = WeatherTestUtils.readJsonData(fromFile: "MockCityResponse.json"),
              let cityResponse = try? JSONDecoder().decode([CityResponse].self, from: response) else {
            return nil
        }
        return cityResponse
    }
}
