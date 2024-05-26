import Foundation


struct ProfileModel {
    let name: String
    let avatarUrl: String
    let subscriptions: [UUID]
    let liked: [UUID]
    let albums: [UUID]
}

struct ProfileRequest: Encodable {
    let name: String
}
