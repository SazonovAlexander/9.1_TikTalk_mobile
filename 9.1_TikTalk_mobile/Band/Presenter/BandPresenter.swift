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
            getNextPodcast()
        }
        self.band = band
    }
    
    func getNextPodcast() {
        do {
            if let podcast = bandFactory?.getNextPodcast() {
                try viewController?.config(podcast: castPodcastModelToPodcast(podcast), animation: self.podcast == nil ? .none : .rigth)
                self.podcast = podcast
            } else {
                viewController?.showErrorAlert(title: "Подкасты закончились", message: nil)
            }
        } catch (let error) {
            viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
        }
    }
    
    func getPrevPodcast() {
        do {
            if let podcast = bandFactory?.getPrevPodcast() {
                try viewController?.config(podcast: castPodcastModelToPodcast(podcast), animation: self.podcast == nil ? .none : .left)
                self.podcast = podcast
            }
        } catch (let error) {
            viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
        }
    }

    func liked() {
        if let podcast {
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
            do {
                try viewController?.config(podcast: castPodcastModelToPodcast(newPodcast), animation: .empty)
            } catch (_) {
                viewController?.showErrorAlert(title: "Ошибка", message: nil)
            }
        }
    }
    
    func album() {
        if let viewController, let podcast {
            router.showAlbumFrom(viewController, album: albumService.getAlbumById(podcast.albumId))
        }
    }
    
    func author() {
        if let viewController, let podcast {
            router.showAuthorFrom(viewController, author: authorService.getAuthorById(podcast.authorId))
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
    
    private func castPodcastModelToPodcast(_ podcastModel: PodcastModel) throws -> Podcast {
        let authorModel = authorService.getAuthorById(podcastModel.authorId)
        
        if let logoUrl = URL(string: podcastModel.logoUrl),
           let audioUrl = URL(string: podcastModel.audioUrl)
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
    
    private func normalizeCountLike(_ count: Int) -> String {
        if count < 10000 {
            return "\(count)"
        } else {
            let formattedString = String(format: "%.1f", Float(count) / 1000.0)
            return "\(formattedString)K"
        }
    }
}

