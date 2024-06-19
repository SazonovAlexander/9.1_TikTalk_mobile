import Foundation


final class AuthorPresenter {
    weak var viewController: AuthorProfileViewController?
    
    private var author: AuthorModel
    private var albums: [AlbumModel] = []
    private var podcasts: [Album] = [] {
        didSet {
            print(podcasts)
            getInfo()
        }
    }
    
    private let albumService: AlbumService
    private let podcastService: PodcastService
    private let authorService: AuthorService
    private let router: AuthorRouter
    
    init(author: AuthorModel,
         albumService: AlbumService = AlbumService(),
         podcastService: PodcastService = PodcastService(),
         authorService: AuthorService = AuthorService(),
         authorRouter: AuthorRouter = AuthorRouter()
    ) {
        self.author = author
        self.albumService = albumService
        self.podcastService = podcastService
        self.authorService = authorService
        self.router = authorRouter
        print(author.albums)
        getAlbums()
    }
    
    private func getAlbums() {
        let dispatchGroup = DispatchGroup()
        var albumModels: [AlbumModel] = []
        var success = true
        var errorMessage = ""
        author.albums.forEach {
            dispatchGroup.enter()
            self.albumService.getAlbumById($0) { result in
                switch result {
                case .success(let album):
                    albumModels.append(album)
                    dispatchGroup.leave()
                case .failure(let error):
                    success = false
                    errorMessage = "Проверьте соединение"
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if success {
                self.albums = albumModels
                self.getPodcasts()
            } else {
                self.viewController?.showErrorAlert(title: "Ошибка", message: errorMessage) {
                    self.viewController?.exit()
                }
                self.albums = []
            }
        }
    }
        
    private func getPodcasts() {
        let dispatchGroup = DispatchGroup()
        var albumsView: [Album] = []
        var albumModels: [AlbumModel] = []
        var success = true
        var errorMessage: String = ""
        dispatchGroup.enter()
        for album in albums {
            dispatchGroup.enter()
            var podcastsInAlbum: [PodcastCell] = []
            var successed = true
            let group1 = DispatchGroup()
            album.podcasts.forEach {
                group1.enter()
                print("beforeid")
                if let id = UUID(uuidString: $0) {
                    print("id")
                    podcastService.getPodcastById(id, completion: { result in
                        switch result {
                        case .success(let podcast):
                            print("success")
                            if let url = URL(string: podcast.logoUrl) {
                                print("url")
                                podcastsInAlbum.append(PodcastCell(name: podcast.name, logoUrl: url))
                            } else {
                                successed = false
                            }
                            group1.leave()
                        case .failure(let error):
                            successed = false
                            errorMessage = "Проверьте соединение"
                            group1.leave()
                        }
                    })
                }
            }
            
            group1.notify(queue: .main, execute: {
                if successed {
                    let albumWithPodcasts = Album(name: album.name, podcasts: podcastsInAlbum)
                    albumsView.append(albumWithPodcasts)
                    albumModels.append(album)
                } else {
                    success = false
                }
                dispatchGroup.leave()
            })
        }
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            if success {
                self.podcasts = albumsView
                self.albums = albumModels
            } else {
                self.viewController?.showErrorAlert(title: "Ошибка", message: errorMessage)
                self.podcasts = []
            }
        }
        
    }
    
    func getInfo() {
        if let avatarUrl = URL(string: author.avatarUrl) {
            let author = Author(
                name: author.name,
                avatarUrl: avatarUrl,
                isSubscribe: author.isSubscribe,
                albums: podcasts
            )
            viewController?.config(author: author)
        } else {
            print("ашибка")
            viewController?.showErrorAlert(title: "Ошибка", message: nil, completion: {[weak self] in
                self?.viewController?.exit()
            })
        }
    }
    
    func showPodcast(indexPath: IndexPath) {
        if let viewController {
            let album = albums[indexPath.section]
            if let id = UUID(uuidString: album.podcasts[indexPath.row]) {
                podcastService.getPodcastById(id) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let podcast):
                        self.router.showPodcastFrom(viewController, podcast: podcast)
                    case .failure(let error):
                        self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                    }
                }
            }
        }
    }
    
    func subscribe() {
        if TokenStorage.shared.accessToken == "" {
            viewController?.showAuthController()
        } else {
            authorService.changeSubscribe(author.id, isSubscribe: !author.isSubscribe) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    self.author = AuthorModel(id: author.id, name: author.name, avatarUrl: author.avatarUrl, isSubscribe: !author.isSubscribe, albums: author.albums)
                    self.getInfo()
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                }
            }
        }
    }
}
