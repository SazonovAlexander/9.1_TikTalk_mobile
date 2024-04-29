import UIKit


final class SearchRouter {
    
    func showPodcastFrom(_ viewController: UIViewController, podcast: PodcastModel) {
        let presenter = PodcastPresenter(podcast: podcast)
        let podcastViewController = PodcastViewController(presenter: presenter)
        presenter.viewController = podcastViewController
        let navController = UINavigationController(rootViewController: podcastViewController)
        viewController.present(navController, animated: true)
    }
}
