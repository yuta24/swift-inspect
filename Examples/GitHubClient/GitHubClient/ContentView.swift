import SwiftUI
import Combine
import OSLog

private let logger = Logger(subsystem: "com.bivre.GitHubClient", category: "session")

class ContentViewModel: ObservableObject {

    @Published
    var text: String = ""
    @Published
    private(set) var users = [User]()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private var searchCancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = .init()

    init() {
        $text.filter(\.isNonEmpty)
            .sink { [weak self] text in
                self?.onSearch(text)
            }
            .store(in: &cancellables)
    }

    private func onSearch(_ text: String) {
        let request = URLRequest(url: .init(string: "https://api.github.com/search/users?q=\(text)")!)
        searchCancellable =  URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: SearchUserResponse.self, decoder: decoder)
            .map { $0.items }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    logger.error("\(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] users in
                self?.users = users
            })
    }

}

struct ContentView: View {

    @StateObject
    private var model: ContentViewModel = .init()

    var body: some View {
        NavigationView {
            List {
                ForEach(model.users) { user in
                    HStack {
                        AsyncImage(url: user.avatarUrl) { phase in
                            phase.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 48, height: 48)

                        Text(user.login)
                    }
                }
            }
            .searchable(text: $model.text) {
            }
            .navigationTitle("Users")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
