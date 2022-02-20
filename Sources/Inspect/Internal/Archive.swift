import Foundation
import ArchiveHelper
import CodableExt

func archive(app: App, device: Device, userDefaults: CodableDictionary<String, Any>, logs: [NetworkLog]) throws -> URL? {
    let directoryURL = URL.TempDirectory.appendingPathComponent("diagnostics", isDirectory: true)

    if !FileManager.default.fileExists(atPath: directoryURL.path) {
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    }

    let appData = try app.encode()
    let deviceData = try device.encode()
    let userDefaultsData = try userDefaults.encode()
    let logsData = try logs.encode()

    let data = [
        (appData, directoryURL.appendingPathComponent("app.txt")),
        (deviceData, directoryURL.appendingPathComponent("device.txt")),
        (userDefaultsData, directoryURL.appendingPathComponent("userdefaults.txt")),
        (logsData, directoryURL.appendingPathComponent("logs.txt")),
    ]

    for (data, fileURL) in data {
        try data.write(to: fileURL, options: .atomic)
    }

    return try ZipArchive(directoryURL).run()
}
