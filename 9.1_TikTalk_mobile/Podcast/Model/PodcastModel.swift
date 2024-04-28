import Foundation


struct PodcastModel: Decodable {
    let id: UUID
    let name: String
    let authorId: UUID
    let description: String
    let albumId: UUID
    let logoUrl: String
    let audioUrl: String
    let countLike: UInt
    let isLiked: Bool
}
