import Foundation
import System

private let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = .prettyPrinted
    return encoder
}()

protocol FileOutputable: Encodable {

    func encode() throws -> Data

}

extension FileOutputable {

    func encode() throws -> Data {
        try encoder.encode(self)
    }

}
