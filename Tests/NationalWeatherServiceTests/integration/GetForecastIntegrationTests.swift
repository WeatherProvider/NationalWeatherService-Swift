import XCTest
@testable import NationalWeatherService

final class GetForecastIntegrationTests: XCTestCase {
    func testGetForecastForLocation() throws {
        let forecastExpectation = self.expectation(description: "get forecast expectation")
        nws.forecast(latitude: 47.6174, longitude: -122.2017) { result in
            XCTAssertSuccess(result)

            let forecast = try! result.get()
            XCTAssertFalse(forecast.periods.isEmpty)

            forecastExpectation.fulfill()
        }

        let hourlyForecastExpectation = self.expectation(description: "get hourly forecast expectation")
        nws.hourlyForecast(latitude: 47.6174, longitude: -122.2017) { result in
            XCTAssertSuccess(result)

            let forecast = try! result.get()
            XCTAssertFalse(forecast.periods.isEmpty)

            hourlyForecastExpectation.fulfill()
        }

        wait(for: [forecastExpectation, hourlyForecastExpectation], timeout: 10)
    }

    static var allTests = [
        ("testGetForecastForLocation", testGetForecastForLocation)
    ]
}
