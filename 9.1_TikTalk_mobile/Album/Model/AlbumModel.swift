import Foundation


struct AlbumModel {
    let id: UUID
    let authorId: UUID
    let name: String
    let description: String
    let podcasts: [UUID]
}
