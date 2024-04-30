import UIKit


final class MyPodcastRouter {
    func showEditPodcastFrom(_ viewController: UIViewController, podcast: PodcastModel) {
        let presenter = CreateEditPodcastPresenter(podcast: podcast, profile: Mocks.profile)
        let createViewController = CreateEditPodcastViewController(presenter: presenter)
        presenter.viewController = createViewController
        viewController.navigationController?.pushViewController(createViewController, animated: true)
    }
    
    func showDescriptionFrom(_ viewController: UIViewController, description: Description) {
        let presenter = DescriptionPresenter(description: description)
        let descriptionViewController = DescriptionViewController(presenter: presenter)
        presenter.viewController = descriptionViewController
        viewController.present(descriptionViewController, animated: true)
    }
}
