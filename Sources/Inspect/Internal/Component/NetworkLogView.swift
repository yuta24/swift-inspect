import SwiftUI

struct NetworkLogView: View {

    let log: NetworkLog

    var body: some View {
        List {
            Section {
                ListItem.subtitle(text: "Method", detail: log.request.method)
                ListItem.subtitle(text: "URL", detail: log.request.url.absoluteString)
                if let body = log.request.body {
                    ListItem.subtitle(text: "Body", detail: body)
                }
                if !log.request.headers.isEmpty {
                    NavigationLink {
                        List {
                            ForEach(Array(log.request.headers.keys), id: \.self) { key in
                                ListItem.value1(text: key, detail: log.request.headers[key]!)
                            }
                        }
                        .navigationTitle("Request Headers")
                    } label: {
                        Text("Headers")
                    }
                }
            } header: {
                Text("Request")
            }

            Section {
                ListItem.subtitle(text: "Status Code", detail: "\(log.response.statusCode)")
                if let body = log.response.body {
                    ListItem.subtitle(text: "Body", detail: body)
                }
            } header: {
                Text("Response")
            }

            Section {
                ListItem.subtitle(text: "Start", detail: log.time.start)
                ListItem.subtitle(text: "End", detail: log.time.end)
            } header: {
                Text("Time")
            }
        }
        .navigationTitle("Network Log")
    }

    init(_ log: NetworkLog) {
        self.log = log
    }

}
