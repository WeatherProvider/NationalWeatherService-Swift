import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NationalWeatherServiceTests.allTests),
        testCase(ForecastTests.allTests),
        testCase(ForecastWindTests.allTests),
        testCase(PointTests.allTests)
    ]
}
#endif
