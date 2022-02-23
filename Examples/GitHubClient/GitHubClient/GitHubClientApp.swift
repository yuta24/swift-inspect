import SwiftUI
import Inspect

@main
struct GitHubClientApp: App {

    @State
    var isInspectPresented: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
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
        Inspect.configure(.default)
    }
}
