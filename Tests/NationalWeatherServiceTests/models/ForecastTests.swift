import XCTest
@testable import NationalWeatherService

final class ForecastTests: XCTestCase {
//    func testForecastHourlyFromURL() throws {
//        let url = URL(string: "https://api.weather.gov/gridpoints/SEW/128,67/forecast/hourly")!
//
//        let loadForecastExpectation = self.expectation(description: "Load Forecast")
//        nws.loadForecast(at: url) { result in
//            XCTAssertSuccess(result)
//            loadForecastExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 100, handler: nil)
//    }
//
//    func testForecastFromURL() throws {
//        let url = URL(string: "https://api.weather.gov/gridpoints/TOP/31,80/forecast")!
//
//        let loadForecastExpectation = self.expectation(description: "Load Forecast")
//        nws.loadForecast(at: url) { result in
//            XCTAssertSuccess(result)
//            loadForecastExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 100, handler: nil)
//    }

    func testForecast() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let forecastData = Fixtures.Forecast_Only_Fixture_SEAW
        let forecast = try decoder.decode(Forecast.self, from: forecastData)

        XCTAssertEqual(forecast.generatedAt, Date(timeIntervalSinceReferenceDate: 607578233))
        XCTAssertEqual(forecast.updated, Date(timeIntervalSinceReferenceDate: 607561537))

        XCTAssertEqual(forecast.validTimes, DateInterval(start: Date(timeIntervalSinceReferenceDate: 607539600),
                                                         end: Date(timeIntervalSinceReferenceDate: 608216400)))
        
        XCTAssertEqual(forecast.elevation.converted(to: .meters).value, 56.997, accuracy: 0.001)

        XCTAssertEqual(forecast.periods.count, 14)

        let period = forecast.periods.first!
        XCTAssertEqual(period.name, "Tonight")
        XCTAssertEqual(period.date, DateInterval(start: Date(timeIntervalSinceReferenceDate: 607575600),
                                                 end: Date(timeIntervalSinceReferenceDate: 607611600)))
        XCTAssertFalse(period.isDaytime)
        XCTAssertEqual(period.temperature.converted(to: .fahrenheit).value, 37.0)
        XCTAssertEqual(period.windSpeed, Forecast.Wind.range(lhs: Measurement(value: 1, unit: UnitSpeed.milesPerHour),
                                                             rhs: Measurement(value: 6, unit: UnitSpeed.milesPerHour),
                                                             direction: .se))
        XCTAssertEqual(period.conditions.count, 1)
        XCTAssertEqual(period.conditions, [.rain_showers])
        XCTAssertEqual(period.shortForecast, "Chance Rain Showers")
        XCTAssertEqual(period.detailedForecast, "A chance of rain showers. Mostly cloudy. Low around 37, with temperatures rising to around 39 overnight. Southeast wind 1 to 6 mph. Chance of precipitation is 50%. New rainfall amounts less than a tenth of an inch possible.")
    }

    static var allTests = [
        ("testForecastTests", testForecast)
    ]
}
