import Foundation

public final class ZipArchive {

    private let source: URL
    private let manager: FileManager

    public init(_ source: URL, manager: FileManager = .default) {
        self.source = source
        self.manager = manager
    }

    public func run() throws -> URL {
        let destination = source.deletingPathExtension().appendingPathExtension("zip")

        if manager.fileExists(atPath: destination.path) {
            try manager.removeItem(at: destination)
        }

        let coordinator = FileCoordinator()
        try coordinator.coordinate(readingItemAt: source, options: [.forUploading], byAccessor: { url in
            try manager.copyItem(at: url, to: destination)
        })
        return destination
    }

}
