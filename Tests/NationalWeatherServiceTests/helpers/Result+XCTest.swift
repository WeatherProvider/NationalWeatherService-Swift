import XCTest

fileprivate func resultIsSuccess<Success, Failure>(_ result: Result<Success, Failure>) -> Bool {
    switch result {
    case .success: return true
    case .failure: return false
    }
}

public func XCTAssertSuccess<Success, Failure>(_ result: Result<Success, Failure>, message: String? = nil) {
    if let message = message {
        XCTAssertTrue(resultIsSuccess(result), message)
    } else {
        XCTAssertTrue(resultIsSuccess(result))
    }
}

public func XCTAssertFailure<Success, Failure>(_ result: Result<Success, Failure>, message: String? = nil) {
    if let message = message {
        XCTAssertFalse(resultIsSuccess(result), message)
    } else {
        XCTAssertFalse(resultIsSuccess(result))
    }
}
