import Foundation


final class MyPodcastPresenter {
    
    weak var viewController: MyPodcastViewController?
    
    private let podcastService: MyPodcastService
    private let router: MyPodcastRouter
    
    private var podcast: PodcastModelWithoutLike {
        didSet {
            getPodcast()
        }
    }
    
    init(
        podcast: PodcastModel,
        podcastService: MyPodcastService = MyPodcastService(),
        router: MyPodcastRouter = MyPodcastRouter()
    ) {
        self.podcast = PodcastModelWithoutLike(
            id: podcast.id,
            name: podcast.name,
            authorId: podcast.authorId,
            description: podcast.description,
            albumId: podcast.albumId,
            logoUrl: podcast.logoUrl,
            audioUrl: podcast.audioUrl,
            countLike: podcast.countLike
        )
        self.podcastService = podcastService
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
    
    private func castPodcastModelToPodcast(_ podcastModel: PodcastModelWithoutLike) throws -> Podcast {
        if let logoUrl = URL(string: podcastModel.logoUrl),
           let audioUrl = URL(string: podcastModel.audioUrl)
        {
            return Podcast(
                        name: podcastModel.name,
                        author: "",
                        countLike: normalizeCountLike(podcastModel.countLike),
                        isLiked: true,
                        logoUrl: logoUrl,
                        audioUrl: audioUrl
                    )
        } else {
            throw PresenterError.parseUrlError(message: "Не удалось загрузить данные")
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
    
    func description() {
        let description = Description(name: podcast.name, description: podcast.description)
        if let viewController {
            router.showDescriptionFrom(viewController, description: description)
        }
    }
    
    func edit() {
        if let viewController {
            router.showEditPodcastFrom(viewController, podcast: podcast)
        }
    }
    
    func delete() {
        viewController?.showConfirmAlert()
    }
    
    func confirmedDelete() {
        podcastService.deletePodcast(podcast.id) {[weak self] result in
            switch result {
            case .success(_):
                self?.viewController?.exit()
            case .failure(let error):
                self?.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
            }
            
        }
    }
}
