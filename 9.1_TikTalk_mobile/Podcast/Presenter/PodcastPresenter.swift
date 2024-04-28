import Foundation

enum PresenterError: Error {
    case parseUrlError(message: String)
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
        albumService: AlbumService = AlbumService()
    ) {
        self.podcast = podcast
        self.podcastService = podcastService
        self.authorService = authorService
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
        let newPodcast = PodcastModel(
            id: podcast.id,
            name: podcast.name,
            authorId: podcast.authorId,
            description: podcast.description,
            albumId: podcast.albumId,
            logoUrl: podcast.logoUrl,
            audioUrl: podcast.audioUrl,
            countLike: podcast.countLike + (podcast.isLiked ? -1 : 1),
            isLiked: !podcast.isLiked
        )
        self.podcast = newPodcast
    }
    
    func album() {
        if let viewController {
            router.showAlbumFrom(viewController, album: albumService.getAlbumById(podcast.albumId))
        }
    }
    
    func author() {
        if let viewController {
            router.showAuthorFrom(viewController, author: authorService.getAuthorById(podcast.authorId))
        }
    }
    
    func description() {
        if let viewController {
            router.showDescriptionFrom(viewController, description: Description(podcastName: podcast.name, description: podcast.description))
        }
    }
    
    func report() {
        if let viewController {
            router.showReportFrom(viewController)
        }
    }
    
    private func castPodcastModelToPodcast(_ podcastModel: PodcastModel) throws -> Podcast {
        let authorModel = authorService.getAuthorById(podcastModel.authorId)
        
        if let logoUrl = URL(string: podcastModel.logoUrl),
           let audioUrl = URL(string: podcastModel.audioUrl) {
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
    
    private func normalizeCountLike(_ count: UInt) -> String {
        if count < 10000 {
            return "\(count)"
        } else {
            let formattedString = String(format: "%.1f", count / 1000)
            return "\(formattedString)K"
        }
    }
    
}
