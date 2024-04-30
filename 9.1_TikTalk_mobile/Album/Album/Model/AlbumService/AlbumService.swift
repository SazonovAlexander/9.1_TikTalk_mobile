import Foundation


final class AlbumService {
    
    func getAlbumById(_ id: UUID) -> AlbumModel {
        Mocks.album
    }
    
    func delete(_ album: AlbumModel) {
        
    }
    
}
