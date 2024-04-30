import UIKit


final class MyAlbumRouter {
    
    func showEditAlbumFrom(_ viewController: UIViewController, album: AlbumModel) {
        
    }
    
    func showDescriptionFrom(_ viewController: UIViewController, description: Description) {
        let presenter = DescriptionPresenter(description: description)
        let descriptionViewController = DescriptionViewController(presenter: presenter)
        presenter.viewController = descriptionViewController
        viewController.present(descriptionViewController, animated: true)
    }
    
    func showMyPodcast(_ viewController: UIViewController, podcast: PodcastModel) {
        
    }
}
