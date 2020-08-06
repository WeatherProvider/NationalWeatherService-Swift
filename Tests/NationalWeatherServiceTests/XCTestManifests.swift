import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ForecastTests.allTests),
        testCase(ForecastWindTests.allTests),
        testCase(PointTests.allTests),
        testCase(GetForecastIntegrationTests.allTests),
        testCase(NationalWeatherServiceTests.allTests),
        testCase(ISO8601DurationTests.allTests)
    ]
}
#endif
