import Foundation
import Combine

final class Manager: ObservableObject {

    static let shared: Manager = .init()

    var session: URLSession!

    @Published
    var networkLoggingEnabled: Bool = true

    private var cancellables: Set<AnyCancellable> = .init()

    init() {
        $networkLoggingEnabled.sink { enabled in
            NetworkRecorder.isRecording = enabled
        }
        .store(in: &cancellables)
    }

}
