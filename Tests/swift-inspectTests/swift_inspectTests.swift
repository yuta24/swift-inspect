import XCTest
@testable import swift_inspect

final class swift_inspectTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_inspect().text, "Hello, World!")
    }
}
