import Foundation


struct AlbumModel: Hashable {
    let id: UUID
    let authorId: UUID
    let name: String
    let description: String
    let podcasts: [UUID]
}
