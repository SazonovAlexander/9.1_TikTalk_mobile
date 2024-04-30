import Foundation


final class AlbumService {
    
    func getAlbumById(_ id: UUID) -> AlbumModel {
        Mocks.album
    }
    
    func delete(_ album: AlbumModel) {
        
    }
    
    func getAllAlbums() -> [AlbumModel] {
        [Mocks.album, Mocks.album, Mocks.album, Mocks.album]
    }
    
}
