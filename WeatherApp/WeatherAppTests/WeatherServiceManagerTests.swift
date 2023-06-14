//
//  WeatherServiceManagerTests.swift
//  WeatherAppTests
//
//  Created by Thomson Varghese on 6/14/23.
//

import XCTest
import  CoreLocation

@testable import WeatherApp

class WeatherServiceManagerTests: XCTestCase {

    var weatherServiceManager: WeatherServiceManager!
    override func setUpWithError() throws {
        weatherServiceManager = WeatherServiceManager()
    }

    override func tearDownWithError() throws {
        weatherServiceManager = nil
    }

    func testObjectNotNil() {
        XCTAssertNotNil(weatherServiceManager, "Object in nil")
    }
    
    func testWeatherFetchSuccess() {
        let expectation = expectation(description: "Get Weather data")
        weatherServiceManager.fetchWeather(for: "Irving") { (result) in
            switch result {
            case .success( _):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Didn't got weather data")
            }
        }
        waitForExpectations(timeout: 5)
    }

    func testCityFetchSuccess() {
        let expectation = expectation(description: "Get City data")
        let location = CLLocation(latitude: 37.33158231, longitude: -122.03070604)
        weatherServiceManager.fetchCityName(from: location) { city in
            if let _ = city {
                expectation.fulfill()
            }
            else {
                XCTFail("Didn't got city")

            }
        }
        waitForExpectations(timeout: 5)
    }
}
