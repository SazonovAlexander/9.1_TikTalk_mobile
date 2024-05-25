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
        if let albumModel = self.album {
            let albumRequest = AlbumModel(id: albumModel.id, authorId: albumModel.authorId, name: album.name, description: album.description, podcasts: albumModel.podcasts)
            albumService.changeAlbum(album: albumRequest) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    self.viewController?.exit()
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
}
