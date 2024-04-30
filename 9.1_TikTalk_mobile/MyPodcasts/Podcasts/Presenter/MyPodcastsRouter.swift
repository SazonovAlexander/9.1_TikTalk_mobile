import UIKit


final class MyPodcastsRouter {
    
    func showMyPodcastFrom(_ viewController: UIViewController, podcast: PodcastModel) {
        let presenter = MyPodcastPresenter(podcast: podcast)
        let myPodcastViewController = MyPodcastViewController(presenter: presenter)
        presenter.viewController = myPodcastViewController
        viewController.navigationController?.pushViewController(myPodcastViewController, animated: true)
    }
    
    func showMyAlbumFrom(_ viewController: UIViewController, album: AlbumModel) {
        let presenter = MyAlbumPresenter(album: album)
        let myAlbumViewController = MyAlbumViewController(presenter: presenter)
        presenter.viewController = myAlbumViewController
        viewController.navigationController?.pushViewController(myAlbumViewController, animated: true)
    }
}
