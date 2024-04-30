import Foundation


final class SearchPresenter {
    weak var viewController: SearchViewController?
    
    private let podcastService: PodcastService
    private let router: SearchRouter
    private var podcasts: [PodcastModel] = [] {
        didSet {
            update()
        }
    }
    
    init(podcastService: PodcastService = PodcastService(),
         searchRouter: SearchRouter = SearchRouter()
    ) {
        self.podcastService = podcastService
        self.router = searchRouter
    }
    
    func search(_ text: String) {
        podcasts = podcastService.search(text)
    }
    
    func showPodcast(index: Int) {
        if let viewController {
            router.showPodcastFrom(viewController, podcast: podcasts[index])
        }
    }
    
    private func update() {
        var podcastsView: [PodcastCell] = []
        podcasts.forEach {
            if let url = URL(string: $0.logoUrl) {
                podcastsView.append(PodcastCell(name: $0.name, logoUrl: url))
            }
        }
        viewController?.update(podcasts: podcastsView)
    }
}
