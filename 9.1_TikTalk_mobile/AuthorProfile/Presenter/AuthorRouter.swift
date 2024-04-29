import UIKit


final class AuthorRouter {
    
    func showPodcastFrom(_ viewController: UIViewController, podcast: PodcastModel) {
        let presenter = PodcastPresenter(podcast: podcast)
        let podcastViewController = PodcastViewController(presenter: presenter)
        presenter.viewController = podcastViewController
        viewController.navigationController?.pushViewController(podcastViewController, animated: true)
    }
}
