import SwiftUI

public struct InspectView: View {

    @ObservedObject
    private var model: InspectViewModel = .init()

    public var body: some View {
        List {
            Section {
                ListItem.subtitle(
                    text: "System Name", detail: model.device.systemName)
                ListItem.subtitle(
                    text: "System Version", detail: model.device.systemVersion)
                ListItem.subtitle(
                    text: "Model Name", detail: model.device.modelName)
                ListItem.subtitle(
                    text: "Language", detail: model.device.language)
            } header: {
                Text("Device")
            }

            Section {
                ListItem.subtitle(
                    text: "Identifier", detail: model.app.identifier)
                ListItem.subtitle(
                    text: "Name", detail: model.app.name)
                ListItem.subtitle(
                    text: "Display Name", detail: model.app.displayName)
                ListItem.subtitle(
                    text: "Version", detail: zip(model.app.shortVersion, model.app.version) { "\($0) (\($1))" } ?? "unknown")
                ListItem.subtitle(
                    text: "Language", detail: model.app.language ?? "unknown")
            } header: {
                Text("Application")
            }

            Section {
                Toggle("Enabled", isOn: $model.networkLoggingEnabled)

                if model.networkLoggingEnabled {
                    NavigationLink {
                        LazyView {
                            if model.logs.isEmpty {
                                Text("no network logs")
                            } else {
                                List(model.logs) { log in
                                    NavigationLink {
                                        NetworkLogView(log)
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text("\(log.response.statusCode)")
                                            Text("\(log.request.url.absoluteString)")
                                        }
                                    }
                                }
                            }
                        }
                        .navigationTitle("Network Logs")
                    } label: {
                        Text("Logs")
                    }
                }
            } header: {
                Text("Network Logging")
            }

            Section {
                NavigationLink {
                    ScrollView {
                        Text("\((model.userDefaultsToString()) ?? "failed: convert to json")")

                        Spacer()
                    }
                    .navigationBarTitle("UserDefaults")
                } label: {
                    Text("Viewer")
                }
            } header: {
                Text("UserDefaults")
            }
        }
        .sheet(isPresented: $model.isActivityPresented) {
            if let url = model.archiveFileURL() {
                Activity(activityItems: [url])
            }
        }
        .navigationBarItems(
            trailing: Button {
                model.isActivityPresented = true
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
        )
    }

    public init() {
    }

}
