import UIKit


final class PodcastRouter {
    
    func showDescriptionFrom(_ viewController: UIViewController, description: Description) {
        let presenter = DescriptionPresenter(description: description)
        let descriptionViewController = DescriptionViewController(presenter: presenter)
        presenter.viewController = descriptionViewController
        descriptionViewController.modalPresentationStyle = .formSheet
        viewController.present(descriptionViewController, animated: true)
    }
    
    func showAuthorFrom(_ viewController: UIViewController, author: AuthorModel) {
        
    }
    
    func showAlbumFrom(_ viewController: UIViewController, album: AlbumModel) {
        
    }
    
    func showReportFrom(_ viewController: UIViewController) {
        
    }
}
