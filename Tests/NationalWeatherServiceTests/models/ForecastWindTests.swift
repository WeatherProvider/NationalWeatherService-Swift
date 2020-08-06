import XCTest
@testable import NationalWeatherService

#if os(iOS) || os(macOS)
final class ForecastWindTests: XCTestCase {
    func testWindSpeedRange() throws {
        // MARK: Text representation
        let single = Forecast.Wind.single(Measurement(value: 10, unit: .milesPerHour), direction: .n)
        XCTAssertEqual(single.description, "10 mph (N)")

        let range = Forecast.Wind.range(lhs: Measurement(value: 10, unit: .milesPerHour),
                                        rhs: Measurement(value: 20, unit: .milesPerHour),
                                        direction: .ne)
        XCTAssertEqual(range.description, "10 mph - 20 mph (NE)")

        // MARK: Handle conversions OK
        let metric = Forecast.Wind.single(Measurement(value: 15, unit: .kilometersPerHour), direction: .sse)
        XCTAssertEqual(metric.description, "9.321 mph (SSE)")

        // MARK: Parsing weather.gov API values
        let parsedUnspecifiedUnitSingle = try Forecast.Wind(from: "15", direction: "N")
        XCTAssertEqual(parsedUnspecifiedUnitSingle.description, "9.321 mph (N)")

        let parsedUnspecifiedUnitRange = try Forecast.Wind(from: "15 - 25", direction: "N")
        XCTAssertEqual(parsedUnspecifiedUnitRange.description, "9.321 mph - 15.534 mph (N)")

        let parsedCustomaryUnitSingle = try Forecast.Wind(from: "10 mph", direction: "NE")
        XCTAssertEqual(parsedCustomaryUnitSingle.description, "10 mph (NE)")

        let parsedNWSCustomaryUnitRange = try Forecast.Wind(from: "10 to 20 mph", direction: "SSE")
        XCTAssertEqual(parsedNWSCustomaryUnitRange.description, "10 mph - 20 mph (SSE)")
    }

    static var allTests = [
        ("testWindSpeedRange", testWindSpeedRange)
    ]
}
#endif
