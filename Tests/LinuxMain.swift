import XCTest

import NationalWeatherServiceTests

var tests = [XCTestCaseEntry]()
tests += NationalWeatherServiceTests.allTests()
tests += ForecastTests.allTests()
tests += ForecastWindTests.allTests()
XCTMain(tests)
