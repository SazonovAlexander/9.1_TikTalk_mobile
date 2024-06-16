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
    let id: String
    let name: String
    let authorId: String
    let description: String
    let albumId: String
    let logoUrl: String?
    let audioUrl: String?
    let countLike: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case authorId = "personId"
        case description
        case albumId
        case logoUrl = "imageUrl"
        case audioUrl
        case countLike = "likes"
    }
}

struct Liked: Decodable {
    let isLiked: Bool
}

struct PodcastRequest: Encodable {
    let name: String
    let description: String
    let albumId: UUID
}
