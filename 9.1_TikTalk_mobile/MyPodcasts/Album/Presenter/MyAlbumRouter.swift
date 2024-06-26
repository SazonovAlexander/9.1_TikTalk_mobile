import UIKit


final class MyAlbumRouter {
    
    func showEditAlbumFrom(_ viewController: UIViewController, album: AlbumModel) {
        let presenter = CreateEditAlbumPresenter(album: album)
        let createEditViewController = CreateEditAlbumViewController(presenter: presenter)
        presenter.viewController = createEditViewController
        viewController.navigationController?.pushViewController(createEditViewController, animated: true)
    }
    
    func showDescriptionFrom(_ viewController: UIViewController, description: Description) {
        let presenter = DescriptionPresenter(description: description)
        let descriptionViewController = DescriptionViewController(presenter: presenter)
        presenter.viewController = descriptionViewController
        viewController.present(descriptionViewController, animated: true)
    }
    
    func showMyPodcast(_ viewController: UIViewController, podcast: PodcastModel) {
        let presenter = MyPodcastPresenter(podcast: podcast)
        let myPodcastViewController = MyPodcastViewController(presenter: presenter)
        presenter.viewController = myPodcastViewController
        viewController.navigationController?.pushViewController(myPodcastViewController, animated: true)
    }
}
