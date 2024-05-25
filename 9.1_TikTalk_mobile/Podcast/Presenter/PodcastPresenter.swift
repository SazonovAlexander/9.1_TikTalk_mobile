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
            getPodcast()
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
        do {
            let podcast = try castPodcastModelToPodcast(self.podcast)
            viewController?.config(podcast: podcast)
        } catch (let error) {
            viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
        }
    }
    
    func liked() {
        podcastService.changeLike(podcast.id, isLiked: !podcast.isLiked) { [weak self] result in
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
            case .failure(let error):
                self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    func album() {
        if let viewController {
            router.showAlbumFrom(viewController, album: albumService.getAlbumById(podcast.albumId))
        }
    }
    
    func author() {
        if let viewController {
            authorService.getAuthorById(podcast.authorId) { [weak self] result in
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
    
    private func castPodcastModelToPodcast(_ podcastModel: PodcastModel) throws -> Podcast {
        let authorModel = getAuthor(id: podcastModel.authorId)
        
        if let logoUrl = URL(string: podcastModel.logoUrl),
           let audioUrl = URL(string: podcastModel.audioUrl),
           let authorModel = authorModel
        {
            return Podcast(
                        name: podcastModel.name,
                        author: authorModel.name,
                        countLike: normalizeCountLike(podcastModel.countLike),
                        isLiked: podcastModel.isLiked,
                        logoUrl: logoUrl,
                        audioUrl: audioUrl
                    )
        } else {
            throw PresenterError.parseUrlError(message: "Не удалось загрузить данные")
        }
    }
    
    private func getAuthor(id: UUID) -> AuthorModel? {
        var author: AuthorModel? = nil
        authorService.getAuthorById(id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let authorModel):
                author = authorModel
            case .failure(let error):
                self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
        
        return author
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
