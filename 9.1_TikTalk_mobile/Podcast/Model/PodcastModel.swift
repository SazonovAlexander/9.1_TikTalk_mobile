import Foundation


struct PodcastModel {
    let id: UUID
    let name: String
    let authorId: UUID
    let description: String
    let albumId: UUID
    let logoUrl: String
    let audioUrl: String
    let countLike: Int
    let isLiked: Bool
}

struct PodcastModelWithoutLike: Decodable {
    let id: UUID
    let name: String
    let authorId: UUID
    let description: String
    let albumId: UUID
    let logoUrl: String
    let audioUrl: String
    let countLike: Int
}

struct Liked: Decodable {
    let isLiked: Bool
}

struct PodcastRequest: Encodable {
    let name: String
    let description: String
    let albumId: UUID
}
