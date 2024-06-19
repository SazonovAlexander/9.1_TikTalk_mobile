import Foundation


final class LikedPresenter {
    weak var viewController: LikedPodcastsViewController?
    
    private let podcastService: PodcastService
    private let router: LikedRouter
    private var profile: ProfileModel
    private lazy var podcasts: [PodcastModel] = [] {
        didSet {
            print(podcasts)
            getInfo()
        }
    }
    
    init(profile: ProfileModel,
         podcastService: PodcastService = PodcastService(),
         likedRouter: LikedRouter = LikedRouter()
    ) {
        self.profile = profile
        self.podcastService = podcastService
        self.router = likedRouter
        getPodcasts()
    }
    
    func showPodcast(index: Int) {
        if let viewController {
            router.showPodcastFrom(viewController, podcast: podcasts[index])
        }
    }
    
    private func getPodcasts() {
        let group = DispatchGroup()
        var podcastModels: [PodcastModel] = []
        var success = true
        var errorMessage: String = ""
        profile.liked.forEach {
            group.enter()
            if let id = UUID(uuidString: $0) {
                podcastService.getPodcastById(id, completion: { result in
                    switch result {
                    case .success(let podcast):
                        podcastModels.append(podcast)
                        group.leave()
                    case .failure(let error):
                        success = false
                        errorMessage = "Проверьте соединение"
                        group.leave()
                    }
                })
            }
        }
        
        group.notify(queue: .main, execute: {
            if success {
                self.podcasts = podcastModels
            } else {
                self.viewController?.showErrorAlert(title: "Ошибка", message: errorMessage)
            }
        })
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
