import UIKit

struct Device: FileOutputable {

    enum Constant {

        static let modelNames: [String: String] = [
            "iPhone7,1": "iPhone 6 Plus",
            "iPhone7,2": "iPhone 6",
            "iPhone8,1": "iPhone 6s",
            "iPhone8,2": "iPhone 6s Plus",
            "iPhone8,4": "iPhone SE",
            "iPhone9,1": "iPhone 7",
            "iPhone9,2": "iPhone 7 Plus",
            "iPhone9,3": "iPhone 7",
            "iPhone9,4": "iPhone 7 Plus",
            "iPhone10,1": "iPhone 8",
            "iPhone10,2": "iPhone 8 Plus",
            "iPhone10,3": "iPhone X",
            "iPhone10,4": "iPhone 8",
            "iPhone10,5": "iPhone 8 Plus",
            "iPhone10,6": "iPhone X",
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max",
            "iPhone11,6": "iPhone XS Max",
            "iPhone11,8": "iPhone XR",
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            "iPhone12,8": "iPhone SE (2nd generation)",
            "iPhone13,1": "iPhone 12 mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone14,4": "iPhone 13 mini",
            "iPhone14,5": "iPhone 13",
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "arm64": "Simulator: \(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknown")"
        ]

    }

    let name: String
    let systemName: String
    let systemVersion: String
    let modelName: String
    let language: String

    init(_ device: UIDevice = .current, _ locale: Locale = .current) {
        self.name = device.name
        self.systemName = device.systemName
        self.systemVersion = device.systemVersion
        self.modelName = {
            var systemInfo = utsname()
            uname(&systemInfo)
            let identifier = Mirror(reflecting: systemInfo.machine).children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return Constant.modelNames[identifier] ?? identifier
        }()
        self.language = locale.languageCode ?? "Unknown"
    }

}
