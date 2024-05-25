import Foundation


final class MyAlbumPresenter {
    
    weak var viewController: MyAlbumViewController?
    
    private var album: AlbumModel
    private let albumService: AlbumService
    private let podcastService: PodcastService
    private let router: MyAlbumRouter
    
    init(album: AlbumModel, 
         albumService: AlbumService = AlbumService(),
         podcastService: PodcastService = PodcastService(),
         myAlbumRouter: MyAlbumRouter = MyAlbumRouter()) {
        self.album = album
        self.albumService = albumService
        self.podcastService = podcastService
        self.router = myAlbumRouter
    }
    
    func getInfo() {
        var podcastsInAlbum: [PodcastCell] = []
        var success = true
        var errorMessage: String = ""
        album.podcasts.forEach {
            podcastService.getPodcastById($0, completion: { result in
                switch result {
                case .success(let podcast):
                    if let url = URL(string: podcast.logoUrl) {
                        podcastsInAlbum.append(PodcastCell(name: podcast.name, logoUrl: url))
                    } else {
                        success = false
                    }
                case .failure(let error):
                    success = false
                    errorMessage = error.localizedDescription
                }
            })
        }
        
        if success {
            let albumWithPodcasts = Album(name: album.name, podcasts: podcastsInAlbum)
            viewController?.config(album: albumWithPodcasts)
        } else {
            viewController?.showErrorAlert(title: "Ошибка", message: errorMessage)
        }
    }
    
    func description() {
        let description = Description(name: album.name, description: album.description)
        if let viewController {
            router.showDescriptionFrom(viewController, description: description)
        }
    }
    
    func podcast(index: Int) {
        if let viewController {
            podcastService.getPodcastById(album.podcasts[index]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let podcast):
                    router.showMyPodcast(viewController, podcast: podcast)
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func edit() {
        if let viewController {
            router.showEditAlbumFrom(viewController, album: album)
        }
    }
    
    func delete() {
        viewController?.showConfirmAlert()
    }
    
    func confirmedDelete() {
        viewController?.exit()
        albumService.delete(album)
    }
}
