import Foundation


final class MyAlbumPresenter {
    
    weak var viewController: MyAlbumViewController?
    
    private var album: AlbumModel
    private let albumService: AlbumService
    private let podcastService: PodcastService
    private let router: MyAlbumRouter
    private var podcasts: Album? {
        didSet {
            if let podcasts {
                getInfo()
            }
        }
    }
    
    init(album: AlbumModel, 
         albumService: AlbumService = AlbumService(),
         podcastService: PodcastService = PodcastService(),
         myAlbumRouter: MyAlbumRouter = MyAlbumRouter()) {
        self.album = album
        self.albumService = albumService
        self.podcastService = podcastService
        self.router = myAlbumRouter
        getPodcasts()
    }
    
    private func getPodcasts() {
        let group = DispatchGroup()
        var podcastsInAlbum: [PodcastCell] = []
        var success = true
        var errorMessage: String = ""
        album.podcasts.forEach {
            group.enter()
            if let id = UUID(uuidString: $0) {
                podcastService.getPodcastByIdWithoutLike(id, completion: { result in
                    switch result {
                    case .success(let podcast):
                        if let url = URL(string: podcast.logoUrl) {
                            podcastsInAlbum.append(PodcastCell(name: podcast.name, logoUrl: url))
                        } else {
                            success = false
                        }
                        group.leave()
                    case .failure(let error):
                        success = false
                        errorMessage = "Проверьте соединение"
                        group.leave()
                    }
                })
            }
        }
        
        group.notify(queue: .main) {
            if success {
                let albumWithPodcasts = Album(name: self.album.name, podcasts: podcastsInAlbum.sorted(by: { $0.name > $1.name }))
                self.podcasts = albumWithPodcasts
                self.podcasts
            } else {
                self.viewController?.showErrorAlert(title: "Ошибка", message: errorMessage)
            }
        }
    }
    
    func getInfo() {
        if let podcasts {
            self.viewController?.config(album: podcasts)
        }
    }
    
    func description() {
        let description = Description(name: album.name, description: album.description)
        if let viewController {
            router.showDescriptionFrom(viewController, description: description)
        }
    }
    
    func podcast(index: Int) {
        if let viewController, let id = UUID(uuidString: album.podcasts[index]){
            podcastService.getPodcastByIdWithoutLike(id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let podcast):
                    router.showMyPodcast(viewController, podcast: podcast)
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                }
            }
        }
    }
    
    func edit() {
        if let viewController {
            router.showEditAlbumFrom(viewController, album: album)
        }
    }
    
    func delete() {
        viewController?.showConfirmAlert()
    }
    
    func confirmedDelete() {
        albumService.deleteAlbum(album.id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                self.viewController?.exit()
            case .failure(let error):
                self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
            }
        }
    }
}
