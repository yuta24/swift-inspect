import Foundation

public struct CodableDictionary<Key: Hashable, Value> {

    private var dictionary: [Key: Value]

    public init(_ dictionary: [Key: Value] = [:]) {
        self.dictionary = dictionary
    }

}

extension CodableDictionary {

    public subscript(key: Key) -> Value? {
        get { dictionary[key] }
        set { dictionary[key] = newValue }
    }

}

extension CodableDictionary: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: (Key, Value)...) {
        var dictionary: [Key: Value] = [:]

        for (key, value) in elements {
            dictionary[key] = value
        }

        self.init(dictionary)
    }

}

struct AnyCodingKeys: CodingKey {

    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }

}

extension UnkeyedDecodingContainer {

    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try nestedContainer(keyedBy: AnyCodingKeys.self)
        return try nestedContainer.decode([String: Any].self)
    }

    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []

        while isAtEnd == false {
            let value: String? = try decode(String?.self)
            if value == nil {
                continue
            }
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Int.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let value = try? decode(Date.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode([Any].self) {
                array.append(nestedArray)
            }
        }
        return array
    }

}

extension KeyedDecodingContainer where K == AnyCodingKeys {

    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try nestedContainer(keyedBy: AnyCodingKeys.self, forKey: key)
        return try container.decode(type, forKey: key)
    }

    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary: [String: Any] = [:]

        for key in allKeys {
            if let value = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Date.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = value
            }
        }

        return dictionary
    }

}

extension UnkeyedEncodingContainer {

    mutating func encode(_ value: [Any]) throws {
        try value.enumerated().forEach({ (index, value) in
            switch value {
            case let value as Bool:
                try encode(value)
            case let value as Int:
                try encode(value)
            case let value as Double:
                try encode(value)
            case let value as String:
                try encode(value)
            case let value as Date:
                try encode(value)
            case let value as [String: Any]:
                try encode(value)
            case let value as [Any]:
                try encode(value)
            case Optional<Any>.none:
                try encodeNil()
            default:
                let keys = AnyCodingKeys(intValue: index).map({ [ $0 ] }) ?? []
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath + keys, debugDescription: "Invalid value"))
            }
        })
    }

    mutating func encode(_ value: [String: Any]) throws {
        var nestedContainer = nestedContainer(keyedBy: AnyCodingKeys.self)
        try nestedContainer.encode(value)
    }

}

extension KeyedEncodingContainer where K == AnyCodingKeys {

    mutating func encode(_ value: [String: Any], forKey key: Key) throws {
        var container = nestedContainer(keyedBy: AnyCodingKeys.self, forKey: key)
        try container.encode(value)
    }

    mutating func encode(_ value: [Any], forKey key: Key) throws {
        var container = nestedUnkeyedContainer(forKey: key)
        try container.encode(value)
    }

    mutating func encode(_ values: [String: Any]) throws {
        for (key, value) in values {
            let key = AnyCodingKeys(stringValue: key)

            switch value {
            case let value as Bool:
                try encode(value, forKey: key)
            case let value as Int:
                try encode(value, forKey: key)
            case let value as Double:
                try encode(value, forKey: key)
            case let value as String:
                try encode(value, forKey: key)
            case let value as Date:
                try encode(value, forKey: key)
            case let value as [String: Any]:
                try encode(value, forKey: key)
            case let value as [Any]:
                try encode(value, forKey: key)
            case Optional<Any>.none:
                try encodeNil(forKey: key)
            default:
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath + [key], debugDescription: "Invalid value"))
            }
        }
    }

}

extension CodableDictionary: Encodable where Key == String, Value == Any {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKeys.self)
        try container.encode(dictionary)
    }

}

extension CodableDictionary: Decodable where Key == String, Value == Any {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKeys.self)
        self.dictionary = try container.decode([String: Any].self)
    }

}
