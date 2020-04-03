import XCTest
@testable import NationalWeatherService

final class ForecastTests: XCTestCase {
    let nws = NationalWeatherService(userAgent: "NationalWeatherService-SwiftPackage-UnitTests")
    let iso8601 = ISO8601DateFormatter()

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

    func testForecast() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let forecastData = Fixtures.Forecast_Only_Fixture_SEAW
        let forecast = try decoder.decode(Forecast.self, from: forecastData)

        XCTAssertEqual(forecast.generatedAt, iso8601.date(from: "2020-04-03T03:43:53+00:00")!)
        XCTAssertEqual(forecast.updated, iso8601.date(from: "2020-04-02T23:05:37+00:00")!)

        XCTAssertEqual(forecast.periods.count, 14)

        let period = forecast.periods.first!
        XCTAssertEqual(period.name, "Tonight")
        XCTAssertEqual(period.date, DateInterval(start: iso8601.date(from: "2020-04-02T20:00:00-07:00")!,
                                                 end: iso8601.date(from: "2020-04-03T06:00:00-07:00")!))
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
        ("testForecastHourlyFromURL", testForecastHourlyFromURL),
        ("testForecastFromURL", testForecastFromURL),
        ("testForecast", testForecast)
    ]
}
