import Foundation


final class AlbumPresenter {
    
    weak var viewController: AlbumViewController?
    
    private var album: AlbumModel
    private lazy var podcasts: [PodcastModel] = {
        album.podcasts.map({podcastService.getPodcastById($0)})
    }()
    
    private let albumService: AlbumService
    private let podcastService: PodcastService
    private let authorService: AuthorService
    private let router: AlbumRouter
    
    init(album: AlbumModel,
         albumService: AlbumService = AlbumService(),
         podcastService: PodcastService = PodcastService(),
         authorService: AuthorService = AuthorService(),
         albumRouter: AlbumRouter = AlbumRouter()
    ) {
        self.album = album
        self.albumService = albumService
        self.podcastService = podcastService
        self.authorService = authorService
        self.router = albumRouter
    }
    
    func getPodcasts() -> [PodcastCell] {
        viewController?.config(name: album.name)
        return podcasts.map{ PodcastCell(name: $0.name, logoUrl: URL(string: $0.logoUrl)) }
    }
    
    func showPodcast(index: Int) {
        if let viewController {
            router.showPodcastFrom(viewController, podcast: podcasts[index])
        }
    }
    
    func showAuthor() {
        if let viewController {
            let author = authorService.getAuthorById(album.authorId)
            router.showAuthorFrom(viewController, author: author)
        }
    }
    
    func showDescription() {
        if let viewController {
            router.showDescriptionFrom(viewController, description: Description(name: album.name, description: album.description))
        }
    }
}
