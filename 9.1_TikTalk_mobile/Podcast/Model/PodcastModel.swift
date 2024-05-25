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
    
    init(id: UUID, name: String, authorId: UUID, description: String, albumId: UUID, logoUrl: String, audioUrl: String, countLike: Int, isLiked: Bool) {
        self.id = id
        self.name = name
        self.authorId = authorId
        self.description = description
        self.albumId = albumId
        self.logoUrl = logoUrl
        self.audioUrl = audioUrl
        self.countLike = countLike
        self.isLiked = isLiked
    }
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
