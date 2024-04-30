import Foundation


final class CreateEditAlbumPresenter {
    
    weak var viewController: CreateEditAlbumViewController?
    
    private var album: AlbumModel?
    private let albumService: AlbumService
    
    init(album: AlbumModel? = nil, albumService: AlbumService = AlbumService()) {
        self.album = album
        self.albumService = albumService
    }
    
    func getInfo() {
        guard let album else { return }
        let albumInfo = AlbumInfo(name: album.name, description: album.description)
        viewController?.config(albumInfo)
    }
    
    func save(_ album: AlbumInfo) {
        //обновление на беке
        viewController?.exit()
    }
}
