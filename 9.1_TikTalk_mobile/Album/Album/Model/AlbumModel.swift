import Foundation


struct AlbumModel: Hashable, Codable {
    let id: UUID
    let authorId: UUID
    let name: String
    let description: String
    let podcasts: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorId = "personId"
        case name = "title"
        case description = "description"
        case podcasts
    }
}

struct AlbumRequest: Encodable {
    let name: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case description
    }
}
