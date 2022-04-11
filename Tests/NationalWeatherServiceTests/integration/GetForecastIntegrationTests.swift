import XCTest
@testable import NationalWeatherService

final class GetForecastIntegrationTests: XCTestCase {
    /// Get forecast without setting `NationalWeatherService.units`
    func testGetForecastForLocation() throws {
        let forecastExpectation = self.expectation(description: "get forecast expectation")
        nws.forecast(latitude: 47.6174, longitude: -122.2017) { result in
            XCTAssertSuccess(result)

            let forecast = try! result.get()
            XCTAssertFalse(forecast.periods.isEmpty)

            forecastExpectation.fulfill()
        }

        wait(for: [forecastExpectation], timeout: 5)
    }
    
    /// Get forecast by setting `NationalWeatherService.units` to `.fahrenheit`
    func testGetForecastFahrenheit() throws {
        let forecastExpectation = self.expectation(description: "get forecast expectation")
        
        NationalWeatherService.units = .fahrenheit
        nws.forecast(latitude: 47.6174, longitude: -122.2017) { result in
            XCTAssertSuccess(result)

            let forecast = try! result.get()
            print(forecast)
            XCTAssertFalse(forecast.periods.isEmpty)

            forecastExpectation.fulfill()
        }

        wait(for: [forecastExpectation], timeout: 5)
    }
    
    /// Get forecast by setting `NationalWeatherService.units` to `.celsius`
    func testGetForecastCelsius() throws {
        let forecastExpectation = self.expectation(description: "get forecast expectation")
        
        NationalWeatherService.units = .celsius
        nws.forecast(latitude: 47.6174, longitude: -122.2017) { result in
            XCTAssertSuccess(result)

            let forecast = try! result.get()
            
            print(forecast)
            XCTAssertFalse(forecast.periods.isEmpty)

            forecastExpectation.fulfill()
        }

        wait(for: [forecastExpectation], timeout: 5)
    }
    
    func testGetHourlyForecast() throws {
        let hourlyForecastExpectation = self.expectation(description: "get hourly forecast expectation")
        nws.hourlyForecast(latitude: 47.6174, longitude: -122.2017) { result in
            XCTAssertSuccess(result)

            let forecast = try! result.get()
            XCTAssertFalse(forecast.periods.isEmpty)

            hourlyForecastExpectation.fulfill()
        }
        wait(for: [hourlyForecastExpectation], timeout: 10)
    }

    static var allTests = [
        ("testGetForecastForLocation", testGetForecastForLocation),
        ("testGetHourlyForecast", testGetHourlyForecast)
    ]
}
