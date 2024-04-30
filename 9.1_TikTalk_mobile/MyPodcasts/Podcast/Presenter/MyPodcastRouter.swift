import UIKit


final class MyPodcastRouter {
    func showEditPodcastFrom(_ viewController: UIViewController, podcast: PodcastModel) {
        
    }
    
    func showDescriptionFrom(_ viewController: UIViewController, description: Description) {
        let presenter = DescriptionPresenter(description: description)
        let descriptionViewController = DescriptionViewController(presenter: presenter)
        presenter.viewController = descriptionViewController
        viewController.present(descriptionViewController, animated: true)
    }
}
