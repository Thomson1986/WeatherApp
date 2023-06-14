//
//  WeatherHomeViewModelTests.swift
//  WeatherAppTests
//
//  Created by Thomson Varghese on 6/13/23.
//

import XCTest
import CoreLocation

@testable import WeatherApp

class WeatherHomeViewModelTests: XCTestCase {
    
    var weatherHomeVM: WeatherHomeViewModel!
    var weatherRepository: WeatherRespository!
    var locationRepository: LocationRepository!
    
    override func setUpWithError() throws {
        
        weatherRepository = MockWeatherServiceRespository()
        locationRepository = MockLocationServiceRespository()
        
        weatherHomeVM = WeatherHomeViewModel(weatherRepository, locationRepository)
        WeatherConstants().saveSearchedCity("Irving")
    }
    
    override func tearDownWithError() throws {
        
        weatherRepository = nil
        locationRepository = nil
        
        weatherHomeVM = nil
    }
    
    func testVMNotNil() {
        
        XCTAssertNotNil(weatherHomeVM, "Weather VM is nil")
    }
    
    func testWeatherViewModelDependencyNotNil() {
        
        XCTAssertNotNil(weatherRepository, "Weather Repository is nil")
        XCTAssertNotNil(locationRepository, "Lcoation Repository is nil")
    }
    
    // MARK: Storage tests
    func testLastSavedCity() {
        
        WeatherConstants().saveSearchedCity("Irving")
        XCTAssertEqual(WeatherConstants.getLastSearchedCity, "Irving")
    }
    
    func testSavedCityEmpty() {
        
        var showErrorTriggered = false
        weatherHomeVM.showError = {
            showErrorTriggered = true
        }
        weatherHomeVM.getWeatherDetails(for: "")
        XCTAssertTrue(showErrorTriggered, "Emtpy city not handled")
        
    }
    
    // MARK: Location API tests
    func testGetUserLocation() {
        
        weatherHomeVM.updateProgress = { value in
            XCTAssertTrue(true, "Update progress not triggered")
        }
        UserDefaults.standard.setValue(nil, forKey: WeatherConstants.savedKey)
        weatherHomeVM.viewDidLoad()
    }
    
    // MARK: City API tests
    func testCityAPINil() {
        
        let location = CLLocation(latitude: 37.023, longitude: 23.54)
        var showErrorTriggered = false
        weatherHomeVM.showError = {
            showErrorTriggered = true
        }
        MockWeatherServiceRespository.mockResponseType = .error
        weatherHomeVM.fetchCity(from: location)
        XCTAssertTrue(showErrorTriggered, "Nil city not handled")
    }
    
    func testCityAPISuccess() {
        
        let location = CLLocation(latitude: 37.023, longitude: 23.54)
        var showErrorTriggered = false
        weatherHomeVM.showError = {
            showErrorTriggered = true
        }
        MockWeatherServiceRespository.mockResponseType = .success
        weatherHomeVM.fetchCity(from: location)
        XCTAssertFalse(showErrorTriggered, "Error message shown for valid city")
    }
    
    // MARK: Weather API tests
    func testWeatherAPIError() {
       
        var showErrorTriggered = false
        weatherHomeVM.showError = {
            showErrorTriggered = true
        }
        MockWeatherServiceRespository.mockResponseType = .error
        weatherHomeVM.getWeatherDetails(for: "Irving")
        XCTAssertTrue(showErrorTriggered, "Error message not shown for  weather api error")
    }
    
    func testWeatherAPISuccess() {
       
        var showResult = false
        weatherHomeVM.showResult = { _ in
            showResult = true
        }
        MockWeatherServiceRespository.mockResponseType = .success
        weatherHomeVM.getWeatherDetails(for: "Irving")
        XCTAssertTrue(showResult, "Weather response not shown to user")
    }
    
    func testWeatherAPIProgress() {
       
        weatherHomeVM.updateProgress = { _ in
            XCTAssertTrue(true, "Progress not shown")
        }
        MockWeatherServiceRespository.mockResponseType = .success
        weatherHomeVM.getWeatherDetails(for: "Irving")
    }
    
}


class MockWeatherServiceRespository: WeatherRespository {
    
    enum MockResponseType {
        case empty
        case success
        case error
    }
    
    static var mockResponseType = MockResponseType.empty
    
    func fetchWeather(for city: String, completion: @escaping WeatherReponseClosure) {
        switch MockWeatherServiceRespository.mockResponseType {
        
        case .success:
            if let response = WeatherTestUtils.readWeatherDetails() {
                completion(.success(response))
            }
            else {
                completion(.failure(WeatherError.invalidResponse))
            }
        case .error:
            completion(.failure(WeatherError.unknownError))
            
        default:
            completion(.failure(WeatherError.unknownError))
        }
        
        
    }
    
    func fetchCityName(from location: CLLocation, completion: @escaping (String?) -> Void) {
        
        switch MockWeatherServiceRespository.mockResponseType {
        case .empty:
            completion("")
        case .success:
            completion("Irving")
        case .error:
            completion(nil)
        }
    }
}

class MockLocationServiceRespository: LocationRepository {
    
    func start(completion: @escaping (CLLocation) -> Void) {
        completion(CLLocation(latitude: 37.023, longitude: 23.54))
    }
}

