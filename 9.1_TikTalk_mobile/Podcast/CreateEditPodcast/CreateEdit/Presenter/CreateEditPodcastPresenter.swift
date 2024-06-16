import Foundation


final class CreateEditPodcastPresenter {
    weak var viewController: CreateEditPodcastViewController?
    
    private var podcast: PodcastModelWithoutLike?
    private let podcastService: MyPodcastService
    private let albumService: AlbumService
    private let router: CreateEditPodcastRouter
    private var isEdit = false
    private var newLogo: URL?
    var logo: URL? = nil {
        didSet {
            newLogo = logo
        }
    }
    var audio: URL? = nil
    var album: AlbumModel? = nil

    
    init(podcast: PodcastModelWithoutLike? = nil,
         podcastService: MyPodcastService = MyPodcastService(),
         albumService: AlbumService = AlbumService(),
         router: CreateEditPodcastRouter = CreateEditPodcastRouter()
    ) {
        self.podcast = podcast
        self.podcastService = podcastService
        self.albumService = albumService
        self.router = router
        initialize()
    }
    
    private func initialize() {
        if let podcast {
            isEdit = true
            if let audioUrl = podcast.audioUrl, let audio = URL(string: audioUrl) {
                self.audio = audio
            }
            if let logoUrl = podcast.logoUrl, let logo = URL(string: logoUrl) {
                self.logo = logo
            }
            
            albumService.getAlbumById(UUID(uuidString: podcast.albumId)!) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let album):
                    self.album = album
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription) {
                        self.viewController?.exit()
                    }
                }
            }
        }
    }
    
    func getInfo() {
        if let podcast {
            let podcastInfo = PodcastInfo(
                name: podcast.name,
                description: podcast.description
            )
            viewController?.config(podcastInfo, isEdit: true)
        } else {
            viewController?.config(nil, isEdit: false)
        }
    }
    
    func save(_ podcast: PodcastInfo) {
        let podcastModel = PodcastModelWithoutLike(
            id: self.podcast?.id ?? UUID().uuidString,
            name: podcast.name,
            authorId: "",
            description: podcast.description,
            albumId: self.album!.id.uuidString,
            logoUrl: self.logo!.absoluteString,
            audioUrl: self.audio!.absoluteString,
            countLike: self.podcast?.countLike ?? 0
        )
        if isEdit {
            podcastService.changePodcastWithoutLogo(podcast: podcastModel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    if let newLogo {
                        podcastService.changePodcastWithLogo(podcast: podcastModel) { [weak self] result in
                            guard let self else { return }
                            switch result {
                            case .success(_):
                                self.viewController?.exit()
                            case .failure(let error):
                                self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                            }
                        }
                    } else {
                        self.viewController?.exit()
                    }
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        } else {
            podcastService.createPodcast(podcast: podcastModel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    podcastService.changePodcastWithLogo(podcast: podcastModel) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(_):
                            self.viewController?.exit()
                        case .failure(let error):
                            self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func selectAlbum() {
        if let viewController {
            router.showSelectAlbumFrom(viewController, selectedAlbum: album, completion: { [weak self] album in
                self?.album = album
                self?.getInfo()
            })
        }
    }
    
    func selectAudio() {
        if let viewController {
            router.showSelectAudioFrom(viewController, completion: { [weak self] audio in
                self?.audio = audio
                self?.getInfo()
            })
        }
    }
    
    func isValid() -> Bool {
        album != nil && logo != nil && audio != nil
    }
}

