import XCTest
import CoreLocation
@testable import NationalWeatherService

final class GetForecastIntegrationTests: XCTestCase {
    func testGetForecastForLocation() throws {
        let location = CLLocation(latitude: 47.6174, longitude: -122.2017)
        let forecastExpectation = self.expectation(description: "get forecast expectation")
        nws.forecast(for: location) { result in
            XCTAssertSuccess(result)

            let forecast = try! result.get()
            XCTAssertFalse(forecast.periods.isEmpty)

            forecastExpectation.fulfill()
        }

        let hourlyForecastExpectation = self.expectation(description: "get hourly forecast expectation")
        nws.hourlyForecast(for: location) { result in
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
