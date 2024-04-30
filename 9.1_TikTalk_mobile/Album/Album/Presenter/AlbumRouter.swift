import UIKit


final class AlbumRouter {
    
    func showAuthorFrom(_ viewController: UIViewController, author: AuthorModel) {
        let presenter = AuthorPresenter(author: author)
        let authorViewController = AuthorProfileViewController(presenter: presenter)
        presenter.viewController = authorViewController
        viewController.navigationController?.pushViewController(authorViewController, animated: true)
    }
    
    func showDescriptionFrom(_ viewController: UIViewController, description: Description) {
        let presenter = DescriptionPresenter(description: description)
        let descriptionViewController = DescriptionViewController(presenter: presenter)
        presenter.viewController = descriptionViewController
        descriptionViewController.modalPresentationStyle = .formSheet
        viewController.present(descriptionViewController, animated: true)
    }
    
    func showPodcastFrom(_ viewController: UIViewController, podcast: PodcastModel) {
        let presenter = PodcastPresenter(podcast: podcast)
        let podcastViewController = PodcastViewController(presenter: presenter)
        presenter.viewController = podcastViewController
        viewController.navigationController?.pushViewController(podcastViewController, animated: true)
    }
}
