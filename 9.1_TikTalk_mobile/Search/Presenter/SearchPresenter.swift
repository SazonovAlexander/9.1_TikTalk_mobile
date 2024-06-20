import Foundation


final class SearchPresenter {
    weak var viewController: SearchViewController?
    
    private let searchService: SearchService
    private let podcastService: PodcastService
    private let router: SearchRouter
    private var lastText = ""
    private var podcasts: [PodcastModel] = [] {
        didSet {
            update()
        }
    }
    
    init(searchService: SearchService = SearchService(),
         podcastService: PodcastService = PodcastService(),
         searchRouter: SearchRouter = SearchRouter()
    ) {
        self.searchService = searchService
        self.podcastService = podcastService
        self.router = searchRouter
    }
    
    func search(_ text: String) {
        if lastText != text {
            podcasts = []
        }
        searchService.search(text) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let podcasts):
                self.podcasts += podcasts
                lastText = text
            case .failure(_):
                break
            }
        }
    }
    
    func showPodcast(index: Int) {
        if let viewController {
            podcastService.getPodcastById(podcasts[index].id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let podcast):
                    self.router.showPodcastFrom(viewController, podcast: podcast)
                case .failure(_):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
                }
            }
        }
    }
    
    private func update() {
        var podcastsView: [PodcastCell] = []
        podcasts.forEach {
            if let url = URL(string: $0.logoUrl) {
                podcastsView.append(PodcastCell(id: $0.id.uuidString.lowercased(), name: $0.name, logoUrl: url))
            }
        }
        viewController?.update(podcasts: podcastsView)
    }
}
