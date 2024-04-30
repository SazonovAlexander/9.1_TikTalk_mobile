import Foundation


struct ProfileModel {
    let id: UUID
    let name: String
    let avatarUrl: String
    let subscriptions: [UUID]
    let liked: [UUID]
    let albums: [UUID]
}
