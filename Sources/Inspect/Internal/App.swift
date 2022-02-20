import Foundation

struct App: FileOutputable {

    let identifier: String
    let name: String
    let displayName: String
    let version: String
    let shortVersion: String
    let language: String?

    init(_ bundle: Bundle = .main) {
        self.identifier = (bundle.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String) ?? "Unknown"
        self.name = (bundle.object(forInfoDictionaryKey: "CFBundleName") as? String) ?? "Unknown"
        self.displayName = (bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? "Unspecified"
        self.version = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        self.shortVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.language = Locale.preferredLanguages.first
    }

}
