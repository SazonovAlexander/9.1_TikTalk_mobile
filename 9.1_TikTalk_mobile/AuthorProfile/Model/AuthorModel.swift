import Foundation

struct AuthorModel {
    let id: UUID
    let name: String
    let avatarUrl: String
    let isSubscribe: Bool
    let albums: [UUID]
}
