import Foundation


final class MyPodcastsPresenter {

    weak var viewController: MyPodcastsViewController?
    
    private var profile: ProfileModel
    private lazy var albums: [AlbumModel] = {        
        var albumModels: [AlbumModel] = []
        var success = true
        var errorMessage = ""
        profile.albums.forEach {
            self.albumService.getAlbumById($0) { result in
                switch result {
                case .success(let album):
                    albumModels.append(album)
                case .failure(let error):
                    success = false
                    errorMessage = error.localizedDescription
                }
            }
        }
        
        if success {
            return albumModels
        } else {
            self.viewController?.showErrorAlert(title: "Ошибка", message: errorMessage) {
                self.viewController?.exit()
            }
            return []
        }
    }()
    
    private let albumService: AlbumService
    private let podcastService: PodcastService
    private let router: MyPodcastsRouter
    
    init(profile: ProfileModel,
         albumService: AlbumService = AlbumService(),
         podcastService: PodcastService = PodcastService(),
         myPodcastsRouter: MyPodcastsRouter = MyPodcastsRouter()
    ) {
        self.profile = profile
        self.albumService = albumService
        self.podcastService = podcastService
        self.router = myPodcastsRouter
    }
        
    private func getPodcasts() -> ([Album]) {
        var albumsView: [Album] = []
        for album in albums {
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
                albumsView.append(albumWithPodcasts)
            } else {
                viewController?.showErrorAlert(title: "Ошибка", message: errorMessage)
                return []
            }
        }
        return albumsView
    }
    
    func getInfo() {
        let podcasts = getPodcasts()
        viewController?.config(albums: podcasts)
    }
    
    func showPodcast(indexPath: IndexPath) {
        if let viewController {
            let album = albums[indexPath.section]
            podcastService.getPodcastById(album.podcasts[indexPath.row]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let podcast):
                    router.showMyPodcastFrom(viewController, podcast: podcast)
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func showAlbum(section: Int) {
        if let viewController {
            router.showMyAlbumFrom(viewController, album: albums[section])
        }
    }
}
