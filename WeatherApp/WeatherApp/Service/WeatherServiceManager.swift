//
//  WeatherServiceManager.swift
//  WeatherApp
//
//  Created by Thomson Varghese on 6/13/23.
//

import Foundation
import CoreLocation

typealias WeatherReponseClosure = (Result<WeatherResponse, WeatherError>) -> Void

protocol WeatherRespository {
    
    func fetchWeather(for city: String,
                      completion: @escaping WeatherReponseClosure)
    func fetchCityName(from location: CLLocation,
                       completion: @escaping (String?) -> Void)
}

//To handle weather serice request
final class WeatherServiceManager {
    
    let apiKey: String
    let weatherUrl: String
    let geoUrl: String

    init() {
        apiKey = WeatherConstants.apiKey
        weatherUrl = WeatherConstants.weatherAPIBaseURL
        geoUrl = WeatherConstants.geoAPIBaseURL
    }
}

extension WeatherServiceManager: WeatherRespository {
    
    //Fetch weather details with city
    func fetchWeather(for city: String, completion: @escaping WeatherReponseClosure) {
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            
            completion(.failure(WeatherError.unknownError))
            return
        }
        
        let urlString = "\(weatherUrl)?q=\(cityEncoded)&appid=\(apiKey)&units=imperial"
        guard let url = URL(string: urlString) else {
            
            completion(.failure(WeatherError.unknownError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let _data = data else {
                completion(.failure(WeatherError.unknownError))
                return
            }
            do {
                let weatherReponse = try JSONDecoder().decode(WeatherResponse.self, from: _data)
                completion(.success(weatherReponse))
            }
            catch {
                completion(.failure(WeatherError.invalidResponse))
            }
        }
        task.resume()
    }
    
    //Fetch city name passing location
    func fetchCityName(from location: CLLocation, completion: @escaping (String?) -> Void) {
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let urlString = "\(geoUrl)?lat=\(latitude)&lon=\(longitude)&limit=1&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let _data = data else {
                completion(nil)
                return
            }
            do {
                let cityResponse = try JSONDecoder().decode([CityResponse].self, from: _data)
                if let cityName = cityResponse.first?.name {
                    completion(cityName)
                    return
                }
                completion(nil)
            }
            catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
