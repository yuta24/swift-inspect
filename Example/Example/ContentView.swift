import SwiftUI

private extension FileManager {

    func sizeOfFile(atPath path: String) throws -> Int64 {
        let attributes = try attributesOfItem(atPath: path)
        return (attributes[.size] as? Int64) ?? 0
    }

    func modificationDateOfFile(atPath path: String) throws -> Date {
        let attributes = try attributesOfItem(atPath: path)
        return (attributes[.modificationDate] as? Date) ?? .init()
    }

}

private let formatter: ByteCountFormatter =  {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useKB]
    formatter.countStyle = .file
    return formatter
}()

struct ExampleView: View {

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack {
                    Button {
                        session.dataTask(with: URL(string: "https://api.github.com/zen")!) { data, response, _ in
                        }
                        .resume()
                    } label: {
                        Text("Request")
                    }
                }
            }
            .navigationTitle("Example")
        }
    }

}
