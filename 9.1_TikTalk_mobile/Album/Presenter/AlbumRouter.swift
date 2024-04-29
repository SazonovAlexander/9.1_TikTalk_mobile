import UIKit


final class AlbumRouter {
    
    func showAuthorFrom(_ viewController: UIViewController, author: AuthorModel) {
        
    }
    
    func showDescriptionFrom(_ viewController: UIViewController, description: Description) {
        let presenter = DescriptionPresenter(description: description)
        let descriptionViewController = DescriptionViewController(presenter: presenter)
        presenter.viewController = descriptionViewController
        descriptionViewController.modalPresentationStyle = .formSheet
        viewController.present(descriptionViewController, animated: true)
    }
}
