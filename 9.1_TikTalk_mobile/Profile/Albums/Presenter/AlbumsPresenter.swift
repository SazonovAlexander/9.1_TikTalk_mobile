import Foundation


final class AlbumsPresenter {
    
    weak var viewController: AlbumsViewController?
        
    private lazy var albums: [AlbumModel] = []
    private var selectedAlbum: AlbumModel? {
        didSet {
            if let selectedAlbum {
                completion(selectedAlbum)
            }
        }
    }
    private var albumsService: AlbumService
    private let router: AlbumsRouter
    private var completion: (AlbumModel) -> Void
    
    init(selectedAlbum: AlbumModel? = nil, albumsService: AlbumService = AlbumService(), router: AlbumsRouter = AlbumsRouter(), completion: @escaping (AlbumModel) -> Void) {
        self.selectedAlbum = selectedAlbum
        self.albumsService = albumsService
        self.router = router
        self.completion = completion
    }
    
    func getInfo() {
        albumsService.getAlbums {[weak self] result in
            switch result {
            case .success(let albumModels):
                let albums = albumModels.map({$0.name})
                self?.viewController?.config(albums)
                self?.albums = albumModels
            case .failure(_):
                self?.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение") {
                    self?.viewController?.exit()
                }
            }
        }
    }
    
    func selectedAlbum(index: Int) {
        selectedAlbum = albums[index]
    }
    
    func selectedAlbumIndex() -> Int? {
        if let selectedAlbum {
            return albums.firstIndex(of: selectedAlbum)
        }
        return nil
    }
    
    func closeViewController() {
        if let selectedAlbum {
            completion(selectedAlbum)
        }
    }
    
    func create() {
        if let viewController {
            router.showCreateAlbumFrom(viewController)
        }
    }
}

