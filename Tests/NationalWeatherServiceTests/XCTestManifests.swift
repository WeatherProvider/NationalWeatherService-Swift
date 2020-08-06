import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ForecastTests.allTests),
//        testCase(ForecastWindTests.allTests),     // Skip this test for Linux. No CustomStringConvertible implementation for Forecast.Wind
        testCase(PointTests.allTests),
        testCase(GetForecastIntegrationTests.allTests),
        testCase(NationalWeatherServiceTests.allTests),
        testCase(ISO8601DurationTests.allTests)
    ]
}
#endif
