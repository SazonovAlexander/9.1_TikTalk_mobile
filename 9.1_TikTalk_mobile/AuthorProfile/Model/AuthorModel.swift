import Foundation

struct AuthorModel {
    let id: UUID
    let name: String
    let avatarUrl: String
    let isSubscribe: Bool
    let albums: [UUID]
}

struct AuthorModelWithoutSubscribe: Decodable {
    let id: String
    let name: String
    let avatarUrl: String?
    let albums: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarUrl = "imageUrl"
        case albums
    }
}

struct IsSubscribe: Decodable {
    let isSubscribe: Bool
}
