import XCTest
@testable import NationalWeatherService

final class NationalWeatherServiceTests: XCTestCase {
    func testForecastFromURL() throws {
        let url = URL(string: "https://api.weather.gov/gridpoints/SEW/128,67/forecast/hourly")!
        let nws = NationalWeatherService(userAgent: "NationalWeatherService-SwiftPackage-UnitTests")

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

    static var allTests = [
        ("testForecastFromURL", testForecastFromURL),
    ]
}
