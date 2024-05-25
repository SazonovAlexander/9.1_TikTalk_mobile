import Foundation


struct AlbumModel: Hashable, Codable {
    let id: UUID
    let authorId: UUID
    let name: String
    let description: String
    let podcasts: [UUID]
}

struct AlbumRequest: Encodable {
    let name: String
    let description: String
}
