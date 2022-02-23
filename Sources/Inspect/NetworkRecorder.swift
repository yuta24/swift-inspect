import Foundation

public final class NetworkRecorder: URLProtocol {

    enum Constant {

        static let handledKey = "NetworkRecorder.handledKey"

    }

    static var isRecording: Bool = false

    private var dataTask: URLSessionDataTask?

    public override class func canInit(with request: URLRequest) -> Bool {
        if Self.property(forKey: Constant.handledKey, in: request) != nil {
            return false
        }

        return isRecording
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override func startLoading() {
        let urlRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        Self.setProperty(true, forKey: Constant.handledKey, in: urlRequest)

        let startDate = Date()

        dataTask = Manager.shared.session.dataTask(with: urlRequest as URLRequest, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }

            let endDate = Date()

            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }

            if let response = response as? HTTPURLResponse {
                NetworkLogStorage.logs.append(.init(startDate, endDate, urlRequest as URLRequest, (data, response)))
                let policy = URLCache.StoragePolicy(rawValue: self.request.cachePolicy.rawValue) ?? .notAllowed
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: policy)
                self.client?.urlProtocol(self, didLoad: data ?? .init())
                self.client?.urlProtocolDidFinishLoading(self)
            }
        })

        dataTask?.resume()
    }

    public override func stopLoading() {
        dataTask?.cancel()
    }

    public static func start() {
        isRecording = true
    }

    public static func stop() {
        isRecording = false
    }

}
