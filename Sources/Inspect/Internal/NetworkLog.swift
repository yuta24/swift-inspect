import Foundation

struct NetworkLog: Identifiable, Encodable, Comparable, FileOutputable {

    struct Request: Encodable {

        let method: String
        let headers: [String: String]
        let url: URL
        let body: String?

        init(_ request: URLRequest) {
            self.method = request.httpMethod ?? "Unknown"
            self.headers = request.allHTTPHeaderFields ?? [:]
            self.url = request.url!
            self.body = request.httpBody.flatMap {
                String(data: $0, encoding: .utf8)
            }
        }

    }

    struct Response: Encodable {

        let statusCode: Int
        let body: String?

        init(_ data: Data?, _ response: HTTPURLResponse) {
            self.statusCode = response.statusCode
            self.body = data.flatMap {
                String(data: $0, encoding: .utf8)
            }
        }

    }

    struct Time: Comparable, Encodable {

        enum Constant {

            static let formatter: ISO8601DateFormatter = {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions.insert(.withFractionalSeconds)
                return formatter
            }()

        }

        let start: String
        let end: String

        init(_ start: Date, _ end: Date) {
            self.start = Constant.formatter.string(from: start)
            self.end = Constant.formatter.string(from: end)
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.start < rhs.start
        }

    }

    let id: UUID

    let request: Request
    let response: Response
    let time: Time

    init(_ start: Date, _ end: Date, _ request: URLRequest, _ response: (Data?, HTTPURLResponse)) {
        self.id = .init()
        self.request = .init(request)
        self.response = .init(response.0, response.1)
        self.time = .init(start, end)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.time < rhs.time
    }


}
