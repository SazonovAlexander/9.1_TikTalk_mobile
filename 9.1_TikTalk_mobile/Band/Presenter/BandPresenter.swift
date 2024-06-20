import Foundation

enum BandAnimation {
    case left
    case rigth
    case none
    case empty
}

final class BandPresenter {
    
    weak var viewController: BandViewController?
    
    private let podcastService: PodcastService
    private let authorService: AuthorService
    private let albumService: AlbumService
    private let router: BandRouter
    private(set) var band: Band?
    private var bandFactory: BandFactory?
    
    init(podcastService: PodcastService = PodcastService(),
         authorService: AuthorService = AuthorService(),
         albumService: AlbumService = AlbumService(),
         router: BandRouter = BandRouter(),
         bandFactory: BandFactory = BandFactory(bandType: .all)
    ) {
        self.podcastService = podcastService
        self.authorService = authorService
        self.albumService = albumService
        self.router = router
        self.bandFactory = bandFactory
    }
    
    private var podcast: PodcastModel?
    
    func updateBand(_ band: Band) {
        bandFactory?.bandType = band.type
        if self.band?.type != band.type {
            self.podcast = nil
        }
        getNextPodcast()
        self.band = band
    }
    
    func getNextPodcast() {
        bandFactory?.getNextPodcast(completion: { podcast in
            if let podcast {
                self.podcastService.getIsLiked(podcast.id) { result in
                    switch result {
                    case .success(let isLiked):
                        let podcastModel = PodcastModel(
                            id: podcast.id,
                            name: podcast.name,
                            authorId: podcast.authorId,
                            description: podcast.description,
                            albumId: podcast.albumId,
                            logoUrl: podcast.logoUrl,
                            audioUrl: podcast.audioUrl,
                            countLike: podcast.countLike,
                            isLiked: isLiked
                        )
                        self.bandFactory?.updateLikeWithourChangeCount(isLiked: isLiked, id: podcastModel.id)
                        self.castPodcastModelToPodcast(podcastModel, animation: self.podcast == nil ? .none : .rigth)
                        self.podcast = podcastModel
                    case .failure(_):
                        self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                    }
                }
            } else {
                self.viewController?.showErrorAlert(title: "Подкасты закончились", message: nil)
            }
        })
    }
    
    func getPrevPodcast() {
        if let podcast = bandFactory?.getPrevPodcast() {
            self.podcastService.getIsLiked(podcast.id) { result in
                switch result {
                case .success(let isLiked):
                    let podcastModel = PodcastModel(
                        id: podcast.id,
                        name: podcast.name,
                        authorId: podcast.authorId,
                        description: podcast.description,
                        albumId: podcast.albumId,
                        logoUrl: podcast.logoUrl,
                        audioUrl: podcast.audioUrl,
                        countLike: podcast.countLike,
                        isLiked: isLiked
                    )
                    self.bandFactory?.updateLikeWithourChangeCount(isLiked: isLiked, id: podcastModel.id)
                    self.castPodcastModelToPodcast(podcastModel, animation: self.podcast == nil ? .none : .left)
                    self.podcast = podcastModel
                case .failure(_):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                }
            }
        }
    }
    
    func liked() {
        if TokenStorage.shared.accessToken == "" {
            viewController?.showAuthController()
        } else {
            if let podcast {
                podcastService.changeLike(podcast.id, isLiked: podcast.isLiked) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(_):
                        let newPodcast = PodcastModel(
                            id: podcast.id,
                            name: podcast.name,
                            authorId: podcast.authorId,
                            description: podcast.description,
                            albumId: podcast.albumId,
                            logoUrl: podcast.logoUrl,
                            audioUrl: podcast.audioUrl,
                            countLike: podcast.countLike + (!podcast.isLiked ? 1 : -1),
                            isLiked: !podcast.isLiked
                        )
                        bandFactory?.updateLike(isLiked: !podcast.isLiked, id: podcast.id)
                        self.podcast = newPodcast
                        castPodcastModelToPodcast(newPodcast, animation: .empty)
                    case .failure(_):
                        self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                    }
                }
            }
        }
    }
    
    func album() {
        if let viewController, let podcast {
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
        if let viewController, let podcast {
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
        if let viewController, let podcast {
            router.showDescriptionFrom(viewController, description: Description(name: podcast.name, description: podcast.description))
        }
    }
    
    func report() {
        if let viewController, let podcast {
            router.showReportFrom(viewController, podcast: podcast)
        }
    }
    
    private func castPodcastModelToPodcast(_ podcastModel: PodcastModel, animation: BandAnimation) {
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
                    viewController?.config(podcast: podcast, animation: animation)
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

