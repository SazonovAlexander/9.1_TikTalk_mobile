import Foundation

struct AuthorModel {
    let id: UUID
    let name: String
    let avatarUrl: String
    let isSubscribe: Bool
    let albums: [UUID]
}

struct AuthorModelWithoutSubscribe: Decodable {
    let id: UUID
    let name: String
    let avatarUrl: String
    let albums: [UUID]
}

struct IsSubscribe: Decodable {
    let isSubscribe: Bool
}
