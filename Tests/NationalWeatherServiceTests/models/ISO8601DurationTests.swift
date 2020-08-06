//
//  ISO8601DurationTests.swift
//  NationalWeatherServiceTests
//
//  Created by Alan Chu on 8/6/20.
//

import XCTest
@testable import NationalWeatherService

class ISO8601DurationTests: XCTestCase {
    func testAllComponents() {
        XCTAssertEqual(ISO8601("P10Y10M3W3DT20H31M21S"),
                       .makeComponents(year: 10, month: 10, weekOfYear: 3, day: 3, hour: 20, minute: 31, second: 21))
        XCTAssertEqual(ISO8601("P1Y2M3DT4H5M6S"),
                       .makeComponents(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6))
    }

    func testJustDate() {
        XCTAssertEqual(ISO8601("P1Y2M3D"),  .makeComponents(year: 1, month: 2, day: 3))
        XCTAssertEqual(ISO8601("P4Y"),      .makeComponents(year: 4))
        XCTAssertEqual(ISO8601("P5Y6D"),    .makeComponents(year: 5, day: 6))
        XCTAssertEqual(ISO8601("P1M"),      .makeComponents(month: 1))
    }

    func testJustTime() {
        XCTAssertEqual(ISO8601("PT1M"), .makeComponents(minute: 1))
        XCTAssertEqual(ISO8601("PT12H10S"), .makeComponents(hour: 12, second: 10))
    }

    func testInvalid() {
        XCTAssertNil(ISO8601("P1Z"))
        XCTAssertNil(ISO8601("P1MM"))
        XCTAssertNil(ISO8601("1M"))
        XCTAssertNil(ISO8601("P1H"))
        XCTAssertNil(ISO8601("PT1D"))
    }

    static var allTests = [
        ("testAllComponents", testAllComponents),
        ("testJustDate", testJustDate),
        ("testJustTime", testJustTime),
        ("testInvalid", testInvalid)
    ]

    private func ISO8601(_ string: String) -> DateComponents? {
        return try? DateComponents(ISO8601String: string)
    }
}

extension DateComponents {
    static func makeComponents(year: Int? = nil,
                               month: Int? = nil,
                               weekOfYear: Int? = nil,
                               day: Int? = nil,
                               hour: Int? = nil,
                               minute: Int? = nil,
                               second: Int? = nil) -> DateComponents {
        var components = DateComponents()
        _ = year.map { components.year = $0 }
        _ = month.map { components.month = $0 }
        _ = day.map { components.day = $0 }
        _ = weekOfYear.map { components.weekOfYear = $0 }
        _ = hour.map { components.hour = $0 }
        _ = minute.map { components.minute = $0 }
        _ = second.map { components.second = $0 }
        return components
    }
}
