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
        let single = Forecast.Wind.single(Measurement(value: 10, unit: .milesPerHour), direction: "N")
        XCTAssertEqual(single.description, "10 mph (N)")

        let range = Forecast.Wind.range(lhs: Measurement(value: 10, unit: .milesPerHour),
                                    rhs: Measurement(value: 20, unit: .milesPerHour),
                                    direction: "NE")
        XCTAssertEqual(range.description, "10 mph - 20 mph (NE)")

        // Handle conversions OK
        let metric = Forecast.Wind.single(Measurement(value: 15, unit: .kilometersPerHour), direction: "SSE")
        XCTAssertEqual(metric.description, "9.321 mph (SSE)")
    }

    static var allTests = [
        ("testForecastFromURL", testForecastFromURL),
        ("testForecastHourlyFromURL", testForecastHourlyFromURL),
        ("testWindSpeedRange", testWindSpeedRange)
    ]
}
