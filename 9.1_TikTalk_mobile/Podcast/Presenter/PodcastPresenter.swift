import Foundation

enum PresenterError: Error {
    case parseUrlError(message: String)
    case requestError(message: String)
}


final class PodcastPresenter {
    
    weak var viewController: PodcastViewController?
    
    private let podcastService: PodcastService
    private let authorService: AuthorService
    private let albumService: AlbumService
    private let router: PodcastRouter
    
    private var podcast: PodcastModel {
        didSet {
            castPodcastModelToPodcast(self.podcast)
        }
    }
    
    init(
        podcast: PodcastModel,
        podcastService: PodcastService = PodcastService(),
        authorService: AuthorService = AuthorService(),
        albumService: AlbumService = AlbumService(),
        router: PodcastRouter = PodcastRouter()
    ) {
        self.podcast = podcast
        self.podcastService = podcastService
        self.authorService = authorService
        self.albumService = albumService
        self.router = router
    }
    
    func getPodcast() {
        castPodcastModelToPodcast(self.podcast)
    }
    
    func liked() {
        if TokenStorage.shared.accessToken == "" {
            viewController?.showAuthController()
        } else {
            podcastService.changeLike(podcast.id, isLiked: podcast.isLiked) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    let newPodcast = PodcastModel(
                        id: self.podcast.id,
                        name: self.podcast.name,
                        authorId: self.podcast.authorId,
                        description: self.podcast.description,
                        albumId: self.podcast.albumId,
                        logoUrl: self.podcast.logoUrl,
                        audioUrl: self.podcast.audioUrl,
                        countLike: self.podcast.countLike + (podcast.isLiked ? -1 : 1),
                        isLiked: !self.podcast.isLiked
                    )
                    self.podcast = newPodcast
                case .failure(_):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                }
            }
        }
    }
    
    func album() {
        if let viewController {
            albumService.getAlbumById(podcast.albumId) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let album):
                    self.router.showAlbumFrom(viewController, album: album)
                case .failure(_):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                }
            }
        }
    }
    
    func author() {
        if let viewController {
            authorService.getAuthorById(podcast.authorId) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let author):
                    self.router.showAuthorFrom(viewController, author: author)
                case .failure(_):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                }
            }
        }
    }
    
    func description() {
        if let viewController {
            router.showDescriptionFrom(viewController, description: Description(name: podcast.name, description: podcast.description))
        }
    }
    
    func report() {
        if let viewController {
            router.showReportFrom(viewController, podcast: podcast)
        }
    }
    
    private func castPodcastModelToPodcast(_ podcastModel: PodcastModel) {
        authorService.getAuthorById(podcastModel.authorId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let authorModel):
                if let logoUrl = URL(string: podcastModel.logoUrl),
                   let audioUrl = URL(string: podcastModel.audioUrl)
                {
                    let podcast = Podcast(
                                name: podcastModel.name,
                                author: authorModel.name,
                                countLike: normalizeCountLike(podcastModel.countLike),
                                isLiked: podcastModel.isLiked,
                                logoUrl: logoUrl,
                                audioUrl: audioUrl
                            )
                    viewController?.config(podcast: podcast)
                }
            case .failure(_):
                self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
            }
        }
    }
    
    private func normalizeCountLike(_ count: Int) -> String {
        if count < 10000 {
            return "\(count)"
        } else {
            let formattedString = String(format: "%.1f", Float(count) / 1000.0)
            return "\(formattedString)K"
        }
    }
    
}
