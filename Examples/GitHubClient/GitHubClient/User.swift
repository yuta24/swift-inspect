import Foundation

struct User: Identifiable, Decodable {

    let id: Int
    let login: String
    let avatarUrl: URL

}
