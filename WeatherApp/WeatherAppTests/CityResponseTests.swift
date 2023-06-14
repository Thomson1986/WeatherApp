//
//  CityResponseTests.swift
//  WeatherAppTests
//
//  Created by Thomson Varghese on 6/14/23.
//

import XCTest
@testable import WeatherApp

class CityResponseTests: XCTestCase {

    var cityResponse: CityResponse!

    override func setUpWithError() throws {
        cityResponse = WeatherTestUtils.readCityDetails()?.first
    }

    override func tearDownWithError() throws {
        cityResponse = nil
    }

    func testCityResponseNil() throws {
        XCTAssertNotNil(cityResponse, "city reponse is nil")
    }

    func testRequiredFields() {
        
        XCTAssertFalse(cityResponse.name?.isEmpty ?? true)
    }

}
