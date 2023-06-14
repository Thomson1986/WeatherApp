//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Thomson Varghese on 6/13/23.
//

import XCTest
@testable import WeatherApp

//Common extension ann utils tests
class WeatherAppTests: XCTestCase {

    func testDoubleStringFormating() {
        let temperature = 12.34
        XCTAssertEqual("12.3", temperature.toString())
    }
}
