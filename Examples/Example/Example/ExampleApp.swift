import SwiftUI
import Inspect

let session: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses?.insert(NetworkRecorder.self, at: 0)
    let session = URLSession(configuration: configuration)
    return session
}()

@main
struct ExampleApp: App {

    @State
    var isInspectPresented: Bool = false

    var body: some Scene {
        WindowGroup {
            ExampleView()
                .onShake {
                    isInspectPresented = true
                }
                .sheet(isPresented: $isInspectPresented) {
                    NavigationView {
                        InspectView()
                            .navigationTitle("Inspect")
                    }
                }
        }
    }

    init() {
        Inspect.configure(.init(session: session, networkLoggingEnabled: true))
    }

}
