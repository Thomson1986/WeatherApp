//
//  WeatherHomeViewModel.swift
//  WeatherApp
//
//  Created by Thomson Varghese on 6/13/23.
//

import Foundation
import CoreLocation

//Interface for Home page view
protocol WeatherHomeViewModelProtocol {
    
    //View state properties - callbacks to view
    var updateProgress: ((Bool) -> Void)? { get set }
    var showResult: ((WeatherResponse) -> Void)? { get set }
    var showError: (() -> Void)? { get set }
    
    //Weather data update methods
    func viewDidLoad()
    func getWeatherDetails(for city: String)
}

final class WeatherHomeViewModel {
    
    var showError: (() -> Void)?
    var showResult: ((WeatherResponse) -> Void)?
    var updateProgress: ((Bool) -> Void)?
    
    private let weatherRespository: WeatherRespository
    private let locationRepository: LocationRepository
    
    init(_ weatherRespository: WeatherRespository,
         _ locationRepository: LocationRepository) {
        self.weatherRespository = weatherRespository
        self.locationRepository = locationRepository
    }
}

// MARK: Weather View Model Delegates
extension WeatherHomeViewModel: WeatherHomeViewModelProtocol {
    
    //Called on load on home page
    //Checked for last searched city
    //Else get current location weather
    func viewDidLoad() {
        
        guard let city = WeatherConstants.getLastSearchedCity else {
            
            locationRepository.start { [weak self] location in
                guard let self = self else { return }
                self.fetchCity(from: location)
            }
            return
        }
        getWeatherDetails(for: city)
    }
    
    func fetchCity(from location: CLLocation) {
        
        updateProgress?(true)
        weatherRespository.fetchCityName(from: location) { [weak self] city in
            guard let self = self else {
                return
            }
            self.updateProgress?(false)
            guard let city = city else {
                self.showError?()
                return
            }
            self.getWeatherDetails(for: city)
        }
    }
    
    //Fetch weather for given city
    func getWeatherDetails(for city: String) {
        
        if city.isEmpty {
            
            self.showError?()
            return
        }
        
        updateProgress?(true)
        weatherRespository.fetchWeather(for: city) { [weak self] result in
            guard let self = self else { return }
            self.updateProgress?(false)
            switch result {
            case .success(let weatherResponse):
                WeatherConstants().saveSearchedCity(city)
                self.showResult?(weatherResponse)
            case .failure(_):
                self.showError?()
            }
        }
    }
}
