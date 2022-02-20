import Foundation

public struct Configuration {

    public static var `default`: Configuration {
        return .init(session: nil, networkLoggingEnabled: true)
    }

    public let session: URLSession?
    public let networkLoggingEnabled: Bool

    public init(session: URLSession?, networkLoggingEnabled: Bool = true) {
        self.session = session
        self.networkLoggingEnabled = networkLoggingEnabled
    }

}
