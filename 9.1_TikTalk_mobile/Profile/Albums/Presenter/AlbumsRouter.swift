import UIKit


final class AlbumsRouter {
    
    func showCreateAlbumFrom(_ viewController: UIViewController) {
        let presenter = CreateEditAlbumPresenter()
        let createAlbumViewController = CreateEditAlbumViewController(presenter: presenter)
        presenter.viewController = createAlbumViewController
        viewController.navigationController?.pushViewController(createAlbumViewController, animated: true)
    }
}
