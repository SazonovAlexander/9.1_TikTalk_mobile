import Foundation


final class SearchPresenter {
    weak var viewController: SearchViewController?
    
    private let searchService: SearchService
    private let router: SearchRouter
    private var podcasts: [PodcastModel] = [] {
        didSet {
            update()
        }
    }
    
    init(searchService: SearchService = SearchService(),
         searchRouter: SearchRouter = SearchRouter()
    ) {
        self.searchService = searchService
        self.router = searchRouter
    }
    
    func search(_ text: String) {
        podcasts = searchService.search(text)
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
