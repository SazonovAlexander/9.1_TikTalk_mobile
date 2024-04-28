import Foundation


final class AlbumService {
    
    func getAlbumById(_ id: UUID) -> AlbumModel {
        AlbumModel(id: UUID(), name: "124", podcasts: [UUID()])
    }
    
}
