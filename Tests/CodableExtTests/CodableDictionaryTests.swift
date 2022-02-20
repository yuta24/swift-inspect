import XCTest
@testable import CodableExt

class CodableDictionaryTests: XCTestCase {

    let dictionary: CodableDictionary<String, Any> = [
        "a": 123,
        "b": "456",
        "c": true,
        "d": [
            "aa": 123,
            "ab": "456",
            "ac": true,
            "ad": Date(timeIntervalSince1970: 1640995200),
            "ae": nil,
        ]
    ]

    func testEncode() throws {
        let encoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .sortedKeys
            return encoder
        }()

        let data = try encoder.encode(dictionary)

        XCTAssertEqual(
            String(data: data, encoding: .utf8),
            #"{"a":123,"b":"456","c":true,"d":{"aa":123,"ab":"456","ac":true,"ad":"2022-01-01T00:00:00Z","ae":null}}"#)
    }

}
