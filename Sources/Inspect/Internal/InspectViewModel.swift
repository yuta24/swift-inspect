import Foundation
import Combine
import CodableExt

private let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = .prettyPrinted
    return encoder
}()

final class InspectViewModel: ObservableObject {

    let device: Device = .init()
    let app: App = .init()
    let userDefaults: CodableDictionary<String, Any> = .init(UserDefaults.standard.dictionaryRepresentation())
    let logs: [NetworkLog] = NetworkLogStorage.logs

    @Published
    var isActivityPresented: Bool = false

    @Published
    var networkLoggingEnabled: Bool

    private var cancellables: Set<AnyCancellable> = .init()

    init(manager: Manager = .shared) {
        self.networkLoggingEnabled = manager.networkLoggingEnabled

        $networkLoggingEnabled.sink { enabled in
            manager.networkLoggingEnabled = enabled
        }
        .store(in: &cancellables)
    }

    func userDefaultsToString() -> String? {
        let data = try? encoder.encode(userDefaults)
        return data.flatMap { String(data: $0, encoding: .utf8) }
    }

    func archiveFileURL() -> URL? {
        do {
            return try archive(app: app, device: device, userDefaults: userDefaults, logs: logs)
        } catch {
            return nil
        }
    }

}
