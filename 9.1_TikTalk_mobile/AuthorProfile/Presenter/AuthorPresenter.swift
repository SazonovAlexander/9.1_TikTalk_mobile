import Foundation


final class AuthorPresenter {
    weak var viewController: AuthorProfileViewController?
    
    private var author: AuthorModel
    private lazy var albums: [AlbumModel] = {
        author.albums.map({self.albumService.getAlbumById($0)})
    }()
    
    private let albumService: AlbumService
    private let podcastService: PodcastService
    private let authorService: AuthorService
    private let router: AuthorRouter
    
    init(author: AuthorModel,
         albumService: AlbumService = AlbumService(),
         podcastService: PodcastService = PodcastService(),
         authorService: AuthorService = AuthorService(),
         authorRouter: AuthorRouter = AuthorRouter()
    ) {
        self.author = author
        self.albumService = albumService
        self.podcastService = podcastService
        self.authorService = authorService
        self.router = authorRouter
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
        if let avatarUrl = URL(string: author.avatarUrl) {
            let author = Author(
                name: author.name,
                avatarUrl: avatarUrl,
                isSubscribe: author.isSubscribe,
                albums: getPodcasts()
            )
            viewController?.config(author: author)
        } else {
            //выбросить ошибку
        }
    }
    
    func showPodcast(indexPath: IndexPath) {
        if let viewController {
            let album = albums[indexPath.section]
            podcastService.getPodcastById(album.podcasts[indexPath.row]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let podcast):
                    self.router.showPodcastFrom(viewController, podcast: podcast)
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func subscribe() {
        author = AuthorModel(id: author.id, name: author.name, avatarUrl: author.avatarUrl, isSubscribe: !author.isSubscribe, albums: author.albums)
        getInfo()
    }
}
