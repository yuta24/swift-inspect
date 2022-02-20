import Foundation

class FileCoordinator {

    let coordinator = NSFileCoordinator()

    func coordinate(readingItemAt url: URL, options: NSFileCoordinator.ReadingOptions = [], byAccessor reader: (URL) throws -> Void) throws {
        var readingError: NSError?
        var accessorError: NSError?

        coordinator.coordinate(readingItemAt: url, options: options, error: &readingError) { url in
            do {
                try reader(url)
            } catch {
                accessorError = error as NSError
            }
        }

        if let readingError = readingError {
            throw readingError
        } else if let accessorError = accessorError {
            throw accessorError
        }
    }

}
