import Foundation


final class MyAlbumPresenter {
    
    weak var viewContoller: MyAlbumViewController?
    
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
        viewContoller?.config(album: albumWithPodcasts)
    }
    
    func description() {
        let description = Description(name: album.name, description: album.description)
        if let viewContoller {
            router.showDescriptionFrom(viewContoller, description: description)
        }
    }
    
    func podcast(index: Int) {
        let podcast = podcastService.getPodcastById(album.podcasts[index])
        if let viewContoller {
            router.showMyPodcast(viewContoller, podcast: podcast)
        }
    }
    
    func delete() {
        viewContoller?.showConfirmAlert()
    }
    
    func confirmedDelete() {
        albumService.delete(album)
    }
}
