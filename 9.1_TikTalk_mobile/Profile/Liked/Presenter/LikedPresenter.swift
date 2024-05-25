import Foundation


final class LikedPresenter {
    weak var viewController: LikedPodcastsViewController?
    
    private let podcastService: PodcastService
    private let router: LikedRouter
    private var profile: ProfileModel
    private lazy var podcasts: [PodcastModel] = {
        var podcastModels: [PodcastModel] = []
        var success = true
        var errorMessage: String = ""
        profile.liked.forEach {
            podcastService.getPodcastById($0, completion: { result in
                switch result {
                case .success(let podcast):
                    podcastModels.append(podcast)
                case .failure(let error):
                    success = false
                    errorMessage = error.localizedDescription
                }
            })
        }
        
        if success {
            return podcastModels
        } else {
            viewController?.showErrorAlert(title: "Ошибка", message: errorMessage)
            return []
        }
    }()
    
    init(profile: ProfileModel,
         podcastService: PodcastService = PodcastService(),
         likedRouter: LikedRouter = LikedRouter()
    ) {
        self.profile = profile
        self.podcastService = podcastService
        self.router = likedRouter
    }
    
    func showPodcast(index: Int) {
        if let viewController {
            router.showPodcastFrom(viewController, podcast: podcasts[index])
        }
    }
    
    func getInfo() {
        var podcastsView: [PodcastCell] = []
        podcasts.forEach {
            if let url = URL(string: $0.logoUrl) {
                podcastsView.append(PodcastCell(name: $0.name, logoUrl: url))
            }
        }
        viewController?.config(podcasts: podcastsView)
    }
}
