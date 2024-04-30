import Foundation


final class MyPodcastsPresenter {

    weak var viewController: MyPodcastsViewController?
    
    private var profile: ProfileModel
    private lazy var albums: [AlbumModel] = {
        profile.albums.map({self.albumService.getAlbumById($0)})
    }()
    
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
    }
        
    private func getPodcasts() -> ([Album]) {
        var albumsView: [Album] = []
        for album in albums {
            var podcastsInAlbum: [PodcastCell] = []
            album.podcasts.forEach({
                let podcast = podcastService.getPodcastById($0)
                if let url = URL(string: podcast.logoUrl) {
                    podcastsInAlbum.append(PodcastCell(name: podcast.name, logoUrl: url))
                } else {
                    //выбросить ошибку
                }
            })
            let albumWithPodcasts = Album(name: album.name, podcasts: podcastsInAlbum)
            albumsView.append(albumWithPodcasts)
        }
        return albumsView
    }
    
    func getInfo() {
        let podcasts = getPodcasts()
        viewController?.config(albums: podcasts)
    }
    
    func showPodcast(indexPath: IndexPath) {
        if let viewController {
            let album = albums[indexPath.section]
            let podcast = podcastService.getPodcastById(album.podcasts[indexPath.row])
            router.showMyPodcastFrom(viewController, podcast: podcast)
        }
    }
    
    func showAlbum(section: Int) {
        if let viewController {
            router.showMyAlbumFrom(viewController, album: albums[section])
        }
    }
}