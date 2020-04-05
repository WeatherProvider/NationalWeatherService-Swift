import XCTest
import CoreLocation
@testable import NationalWeatherService

final class PointTests: XCTestCase {
    let nws = NationalWeatherService(userAgent: "NationalWeatherService-SwiftPackage-UnitTests")
    
    func testSeattlePointFromURL() throws {
        let url = URL(string: "https://api.weather.gov/points/47.6174,-122.2017")!

        let loadPointExpectation = self.expectation(description: "Load Point")
        nws.loadPoint(at: url) { result in
            XCTAssertSuccess(result)
            loadPointExpectation.fulfill()
        }

        waitForExpectations(timeout: 1000)
    }

    func testSeattlePoint() throws {
        let coordinates = CLLocationCoordinate2D(latitude: 47.6174, longitude: -122.2017)

        let loadPointExpectation = self.expectation(description: "Load Point")
        nws.loadPoint(for: coordinates) { result in
            XCTAssertSuccess(result)
            loadPointExpectation.fulfill()
        }
        waitForExpectations(timeout: 1000)
    }

    func testPoint() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let pointData = Fixtures.PointOnly_Fixture_BellevueWA
        let point = try decoder.decode(Point.self, from: pointData)

        XCTAssertEqual(point.cwa, "SEW")
        XCTAssertEqual(point.gridX, 128)
        XCTAssertEqual(point.gridY, 67)

        XCTAssertEqual(point.forecast.absoluteString, "https://api.weather.gov/gridpoints/SEW/128,67/forecast")
        XCTAssertEqual(point.forecastHourly.absoluteString, "https://api.weather.gov/gridpoints/SEW/128,67/forecast/hourly")

        XCTAssertEqual(point.timeZone, "America/Los_Angeles")
        XCTAssertEqual(point.radarStation, "KATX")
    }

    static var allTests = [
        ("testSeattlePoint", testSeattlePoint),
        ("testSeattlePointFromURL", testSeattlePointFromURL),
        ("testPoint", testPoint)
    ]
}
