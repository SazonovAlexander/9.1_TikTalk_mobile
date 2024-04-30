import UIKit


final class BandRouter {
    
    func showDescriptionFrom(_ viewController: UIViewController, description: Description) {
        let presenter = DescriptionPresenter(description: description)
        let descriptionViewController = DescriptionViewController(presenter: presenter)
        presenter.viewController = descriptionViewController
        viewController.present(descriptionViewController, animated: true)
    }
    
    func showAuthorFrom(_ viewController: UIViewController, author: AuthorModel) {
        let presenter = AuthorPresenter(author: author)
        let authorViewController = AuthorProfileViewController(presenter: presenter)
        presenter.viewController = authorViewController
        let navController = UINavigationController(rootViewController: authorViewController)
        navController.navigationBar.backItem?.title = "Назад"
        viewController.present(navController, animated: true)
    }
    
    func showAlbumFrom(_ viewController: UIViewController, album: AlbumModel) {
        let presenter = AlbumPresenter(album: album)
        let albumViewController = AlbumViewController(presenter: presenter)
        presenter.viewController = albumViewController
        let navController = UINavigationController(rootViewController: albumViewController)
        navController.navigationBar.backItem?.title = "Назад"
        viewController.present(navController, animated: true)
    }
    
    func showReportFrom(_ viewController: UIViewController, podcast: PodcastModel) {
        let presenter = ReportPresenter(podcast: podcast)
        let reportViewController = ReportViewController(presenter: presenter)
        presenter.viewController = reportViewController
        let navController = UINavigationController(rootViewController: reportViewController)
        navController.navigationBar.backItem?.title = "Назад"
        viewController.present(navController, animated: true)
    }
}
