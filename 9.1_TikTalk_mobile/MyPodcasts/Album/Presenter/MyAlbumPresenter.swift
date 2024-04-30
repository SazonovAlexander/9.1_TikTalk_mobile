import Foundation


final class MyAlbumPresenter {
    
    weak var viewController: MyAlbumViewController?
    
    private var album: AlbumModel
    private let albumService: AlbumService
    private let podcastService: PodcastService
    private let router: MyAlbumRouter
    
    init(album: AlbumModel, 
         albumService: AlbumService = AlbumService(),
         podcastService: PodcastService = PodcastService(),
         myAlbumRouter: MyAlbumRouter = MyAlbumRouter()) {
        self.album = album
        self.albumService = albumService
        self.podcastService = podcastService
        self.router = myAlbumRouter
    }
    
    func getInfo() {
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
        viewController?.config(album: albumWithPodcasts)
    }
    
    func description() {
        let description = Description(name: album.name, description: album.description)
        if let viewController {
            router.showDescriptionFrom(viewController, description: description)
        }
    }
    
    func podcast(index: Int) {
        let podcast = podcastService.getPodcastById(album.podcasts[index])
        if let viewController {
            router.showMyPodcast(viewController, podcast: podcast)
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
        albumService.delete(album)
    }
}
