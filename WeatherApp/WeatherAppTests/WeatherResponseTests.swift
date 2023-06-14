//
//  WeatherResponseTests.swift
//  WeatherAppTests
//
//  Created by Thomson Varghese on 6/14/23.
//

import XCTest
@testable import WeatherApp

class WeatherResponseTests: XCTestCase {

    var weatherResponse: WeatherResponse!
    
    override func setUpWithError() throws {
        weatherResponse = WeatherTestUtils.readWeatherDetails()
    }

    override func tearDownWithError() throws {
        weatherResponse = nil
    }

    func testWeatherResponseNil() throws {
        XCTAssertNotNil(weatherResponse, "weather is nil")
    }

    func testRequiredFields() {
        
        XCTAssertFalse(weatherResponse.weather?.first?.description?.isEmpty ?? true)
        XCTAssertFalse(weatherResponse.main?.feelsLike?.isNaN ?? true)
        XCTAssertFalse(weatherResponse.main?.temperature?.isNaN ?? true)
        XCTAssertFalse(weatherResponse.wind?.speed?.isNaN ?? true)
        XCTAssertFalse(weatherResponse.name.isEmpty)
    }
}
