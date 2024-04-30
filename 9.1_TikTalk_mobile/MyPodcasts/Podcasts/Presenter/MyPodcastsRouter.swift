import UIKit


final class MyPodcastsRouter {
    
    func showMyPodcastFrom(_ viewController: UIViewController, podcast: PodcastModel) {
//        let presenter = PodcastPresenter(podcast: podcast)
//        let podcastViewController = PodcastViewController(presenter: presenter)
//        presenter.viewController = podcastViewController
//        viewController.navigationController?.pushViewController(podcastViewController, animated: true)
    }
    
    func showMyAlbumFrom(_ viewController: UIViewController, album: AlbumModel) {
        let presenter = MyAlbumPresenter(album: album)
        let myAlbumViewController = MyAlbumViewController(presenter: presenter)
        presenter.viewController = myAlbumViewController
        viewController.navigationController?.pushViewController(myAlbumViewController, animated: true)
    }
}
