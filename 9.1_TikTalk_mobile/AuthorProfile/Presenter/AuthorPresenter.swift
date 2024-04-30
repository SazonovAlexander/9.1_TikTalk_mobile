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
            album.podcasts.forEach({
                let podcast = podcastService.getPodcastById($0)
                if let url = URL(string: podcast.logoUrl) {
                    podcastsInAlbum.append(PodcastCell(name: podcast.name, logoUrl: url))
                } else {
                    //выбросить ошибку
                }
            })
            let albumWithPodcasts = Album(name: album.name, podcasts: podcastsInAlbum)
            albumsView.append(albumWithPodcasts)
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
            let podcast = podcastService.getPodcastById(album.podcasts[indexPath.row])
            router.showPodcastFrom(viewController, podcast: podcast)
        }
    }
    
    func subscribe() {
        author = AuthorModel(id: author.id, name: author.name, avatarUrl: author.avatarUrl, isSubscribe: !author.isSubscribe, albums: author.albums)
        getInfo()
    }
}
