import Foundation


final class MyPodcastsPresenter {

    weak var viewController: MyPodcastsViewController?
    
    private var profile: ProfileModel
    private var albums: [AlbumModel] = []
    private var podcasts: [Album] = [] {
        didSet {
            print(podcasts.count)
            getInfo()
        }
    }
    
    private let albumService: AlbumService
    private let podcastService: PodcastService
    private let router: MyPodcastsRouter
    
    init(profile: ProfileModel,
         albumService: AlbumService = AlbumService(),
         podcastService: PodcastService = PodcastService(),
         myPodcastsRouter: MyPodcastsRouter = MyPodcastsRouter()
    ) {
        self.profile = profile
        self.albumService = albumService
        self.podcastService = podcastService
        self.router = myPodcastsRouter
        getAlbums()
    }
    
    private func getAlbums() {
        let dispatchGroup = DispatchGroup()
        var albumModels: [AlbumModel] = []
        var success = true
        var errorMessage = ""
        print(profile.albums.count)
        profile.albums.forEach {
            dispatchGroup.enter()
            if let id = UUID(uuidString: $0) {
                self.albumService.getAlbumById(id) { result in
                    switch result {
                    case .success(let album):
                        albumModels.append(album)
                        dispatchGroup.leave()
                    case .failure(let error):
                        success = false
                        errorMessage = error.localizedDescription
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if success {
                self.albums = albumModels
                self.getPodcasts()
            } else {
                print("error 1")
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
                if let id = UUID(uuidString: $0) {
                    podcastService.getPodcastByIdWithoutLike(id, completion: { result in
                        switch result {
                        case .success(let podcast):
                            if let url = URL(string: podcast.logoUrl) {
                                podcastsInAlbum.append(PodcastCell(name: podcast.name, logoUrl: url))
                            } else {
                                print("error 4")
                                successed = false
                            }
                            group1.leave()
                        case .failure(let error):
                            print("error 3")
                            successed = false
                            errorMessage = error.localizedDescription
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
                print("error 2")
                self.viewController?.showErrorAlert(title: "Ошибка", message: errorMessage)
                self.podcasts = []
            }
        }
        
    }
    
    func getInfo() {
        viewController?.config(albums: podcasts)
    }
    
    func showPodcast(indexPath: IndexPath) {
        if let viewController {
            let album = albums[indexPath.section]
            if let id = UUID(uuidString: album.podcasts[indexPath.row]) {
                podcastService.getPodcastById(id) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let podcast):
                        router.showMyPodcastFrom(viewController, podcast: podcast)
                    case .failure(let error):
                        self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func showAlbum(section: Int) {
        if let viewController {
            router.showMyAlbumFrom(viewController, album: albums[section])
        }
    }
}
