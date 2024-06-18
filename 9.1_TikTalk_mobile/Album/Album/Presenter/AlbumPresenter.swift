import Foundation


final class AlbumPresenter {
    
    weak var viewController: AlbumViewController?
    
    private var album: AlbumModel
    private lazy var podcasts: [PodcastModel] = [] {
        didSet {
            getInfo()
        }
    }
    
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
        getPodcasts()
    }
    
    private func getPodcasts() {
        let group = DispatchGroup()
        var podcastsModels: [PodcastModel] = []
        var success = true
        var errorMessage: String = ""
        album.podcasts.forEach {
            group.enter()
            if let id = UUID(uuidString: $0) {
                podcastService.getPodcastById(id, completion: { result in
                    switch result {
                    case .success(let podcast):
                        podcastsModels.append(podcast)
                        group.leave()
                    case .failure(let error):
                        success = false
                        errorMessage = error.localizedDescription
                        group.leave()
                    }
                })
            }
        }
        
        group.notify(queue: .main) {
            if success {
                self.podcasts = podcastsModels
            } else {
                self.viewController?.showErrorAlert(title: "Ошибка", message: errorMessage)
            }
        }
    }
    
    func getInfo() {
        viewController?.config(name: album.name, podcasts: podcasts.map{ PodcastCell(name: $0.name, logoUrl: URL(string: $0.logoUrl))})
    }
    
    func showPodcast(index: Int) {
        if let viewController {
            router.showPodcastFrom(viewController, podcast: podcasts[index])
        }
    }
    
    func showAuthor() {
        if let viewController {
            authorService.getAuthorById(album.authorId) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let author):
                    self.router.showAuthorFrom(viewController, author: author)
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func showDescription() {
        if let viewController {
            router.showDescriptionFrom(viewController, description: Description(name: album.name, description: album.description))
        }
    }
}
