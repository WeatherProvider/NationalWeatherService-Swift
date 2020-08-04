import XCTest

public func XCTAssertSuccess<Success, Failure>(_ result: Result<Success, Failure>, message: String? = nil) {
    switch result {
    case .success: break
    case .failure(let error):
        if let message = message {
            XCTFail("XCTAssertSuccess failed, \(message). Failure Error: \(error as NSError)")
        } else {
            XCTFail("XCTAssertSuccess failed: \(error as NSError)")
        }
    }
}

public func XCTAssertFailure<Success, Failure>(_ result: Result<Success, Failure>, message: String? = nil) {
    switch result {
    case .failure: break
    case .success:
        if let message = message {
            XCTFail("XCTAssertFailure failed, \(message)")
        } else {
            XCTFail("XCTAssertFailure failed")
        }
    }

}
