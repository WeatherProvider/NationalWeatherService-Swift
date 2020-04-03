import XCTest
@testable import NationalWeatherService

final class NationalWeatherServiceTests: XCTestCase {
    let nws = NationalWeatherService(userAgent: "NationalWeatherService-SwiftPackage-UnitTests")

    func testForecastHourlyFromURL() throws {
        let url = URL(string: "https://api.weather.gov/gridpoints/SEW/128,67/forecast/hourly")!

        let loadForecastExpectation = self.expectation(description: "Load Forecast")
        nws.loadForecast(at: url) { result in
            switch result {
            case .success(let forecast):
                forecast.periods.forEach {
                    print($0)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }

            loadForecastExpectation.fulfill()
        }

        waitForExpectations(timeout: 100, handler: nil)
    }

    func testForecastFromURL() throws {
        let url = URL(string: "https://api.weather.gov/gridpoints/TOP/31,80/forecast")!

        let loadForecastExpectation = self.expectation(description: "Load Forecast")
        nws.loadForecast(at: url) { result in
            switch result {
            case .success(let forecast):
                forecast.periods.forEach {
                    print($0)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }

            loadForecastExpectation.fulfill()
        }

        waitForExpectations(timeout: 100, handler: nil)
    }

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
        ("testForecastFromURL", testForecastFromURL),
        ("testForecastHourlyFromURL", testForecastHourlyFromURL),
        ("testWindSpeedRange", testWindSpeedRange)
    ]
}
