import Foundation


final class CreateEditPodcastPresenter {
    weak var viewController: CreateEditPodcastViewController?
    
    private var podcast: PodcastModel?
    private var profile: ProfileModel
    private let podcastService: PodcastService
    private let albumService: AlbumService
    private let router: CreateEditPodcastRouter
    var logo: URL? = nil
    var audio: URL? = nil
    var album: AlbumModel? = nil
    
    init(podcast: PodcastModel? = nil,
         profile: ProfileModel,
         podcastService: PodcastService = PodcastService(),
         albumService: AlbumService = AlbumService(),
         router: CreateEditPodcastRouter = CreateEditPodcastRouter()
    ) {
        self.podcast = podcast
        self.profile = profile
        if let podcast {
            if let audio = URL(string: podcast.audioUrl) {
                self.audio = audio
            }
            if let logo = URL(string: podcast.logoUrl) {
                self.logo = logo
            }
            
            album = albumService.getAlbumById(podcast.albumId)
        }
        self.podcastService = podcastService
        self.albumService = albumService
        self.router = router
    }
    
    func getInfo() {
        if let podcast {
            let podcastInfo = PodcastInfo(
                name: podcast.name,
                description: podcast.description
            )
            viewController?.config(podcastInfo)
        } else {
            viewController?.config(nil)
        }
    }
    
    func save(_ podcast: PodcastInfo) {
        //обноваление на беке
        viewController?.exit()
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
            })
        }
    }
    
    func isValid() -> Bool {
        album != nil && logo != nil// && audio != nil
    }
}

