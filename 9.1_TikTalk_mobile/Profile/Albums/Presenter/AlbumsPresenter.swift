import Foundation


final class AlbumsPresenter {
    
    weak var viewController: AlbumsViewController?
        
    private var albums: [AlbumModel] {
        albumsService.getAllAlbums()
    }
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
        let albums = albums.map({$0.name})
        viewController?.config(albums)
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

