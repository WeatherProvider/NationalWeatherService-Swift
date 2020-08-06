import XCTest
@testable import NationalWeatherService

final class NationalWeatherServiceTests: XCTestCase {
    func testCurrentConditions() throws {
        let expectation = self.expectation(description: "Get current weather at location.")
        nws.currentCondition(latitude: 47.6174, longitude: -122.2017) { result in
            XCTAssertSuccess(result)

            let period = try! result.get()
            print(period)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 60)
    }

    static var allTests = [
        ("testCurrentConditions", testCurrentConditions)
    ]
}
