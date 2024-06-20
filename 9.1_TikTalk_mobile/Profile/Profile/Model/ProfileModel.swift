import Foundation


struct ProfileModel: Decodable {
    let name: String
    let avatarUrl: String?
    let subscriptions: [String]
    let liked: [String]
    let albums: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case avatarUrl = "imageUrl"
        case subscriptions = "subscriptions"
        case liked = "likedPodcasts"
        case albums
    }
}

struct ProfileRequest: Encodable {
    let name: String
}
