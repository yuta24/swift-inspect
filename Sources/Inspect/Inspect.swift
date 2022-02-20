import Foundation

public enum Inspect {

    public static func configure(_ configuration: Configuration = .default) {
        Manager.shared.networkLoggingEnabled = configuration.networkLoggingEnabled

        if let session = configuration.session {
            Manager.shared.session = session
        } else {
            URLProtocol.registerClass(NetworkRecorder.self)
            Manager.shared.session = .shared
        }
    }

}
