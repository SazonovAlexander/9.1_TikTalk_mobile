import Foundation

enum PresenterError: Error {
    case parseUrlError(message: String)
}


final class PodcastPresenter {
    
    weak var viewController: PodcastViewController?
    
    private let podcastService: PodcastService
    private let authorService: AuthorService
    
    private var podcast: PodcastModel
    
    init(
        podcast: PodcastModel,
        podcastService: PodcastService = PodcastService(),
        authorService: AuthorService = AuthorService()
    ) {
        self.podcast = podcast
        self.podcastService = podcastService
        self.authorService = authorService
    }
    
    func getPodcast() -> Podcast? {
        var podcast: Podcast?
        do {
            podcast = try castPodcastModelToPodcast(self.podcast)
        } catch (let error) {
            viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
        }
        return podcast
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
