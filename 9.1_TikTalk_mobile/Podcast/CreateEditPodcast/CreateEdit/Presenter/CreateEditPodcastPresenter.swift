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
            
            let selectedAlbum: AlbumModel? = nil
            let group = DispatchGroup()
            group.enter()
            albumService.getAlbumById(UUID(uuidString: podcast.albumId)!) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let album):
                    self.album = album
                    group.leave()
                case .failure(_):
                    group.leave()
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение") {
                        self.viewController?.exit()
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.album = selectedAlbum
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
    
    func save(_ podcastInfo: PodcastInfo) {
        var podcastModel = PodcastModelWithoutLike(
            id: self.podcast?.id ?? UUID().uuidString,
            name: podcastInfo.name,
            authorId: "",
            description: podcastInfo.description,
            albumId: self.album!.id.uuidString,
            logoUrl: self.logo!.absoluteString,
            audioUrl: self.audio!.absoluteString,
            countLike: self.podcast?.countLike ?? 0
        )
        if isEdit {
            podcastService.changePodcast(podcast: podcastModel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    if let newLogo {
                        podcastService.changeAvatar(podcast: podcastModel) { [weak self] result in
                            guard let self else { return }
                            switch result {
                            case .success(_):
                                self.viewController?.exit()
                            case .failure(_):
                                self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                            }
                        }
                    } else {
                        self.viewController?.exit()
                    }
                case .failure(_):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                }
            }
        } else {
            let group = DispatchGroup()
            group.enter()
            var success = true
            podcastService.createPodcast(podcast: podcastModel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let id):
                    podcastModel.id = id
                    group.leave()
                    viewController?.exit()
                case .failure(_):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                    success = false
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                if success {
                    let group1 = DispatchGroup()
                    group1.enter()
                    self.podcastService.changeAudio(podcast: podcastModel) { result in
                        switch result {
                        case .success(_):
                            group1.leave()
                        case .failure(_):
                            group1.leave()
                        }
                    }
                    group1.enter()
                    self.podcastService.changeAvatar(podcast: podcastModel) { result in
                        switch result {
                        case .success(_):
                            group1.leave()
                        case .failure(_):
                            group1.leave()
                        }
                    }
                    
                    group1.notify(queue: .main) { [weak self] in
                        self?.viewController?.exit()
                    }
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

