import UIKit


final class BandRouter {
    
    func showDescriptionFrom(_ viewController: UIViewController, description: Description) {
        let presenter = DescriptionPresenter(description: description)
        let descriptionViewController = DescriptionViewController(presenter: presenter)
        presenter.viewController = descriptionViewController
        descriptionViewController.modalPresentationStyle = .formSheet
        viewController.present(descriptionViewController, animated: true)
    }
    
    func showAuthorFrom(_ viewController: UIViewController, author: AuthorModel) {
        let presenter = AuthorPresenter(author: author)
        let authorViewController = AuthorProfileViewController(presenter: presenter)
        presenter.viewController = authorViewController
        viewController.navigationController?.pushViewController(authorViewController, animated: true)
    }
    
    func showAlbumFrom(_ viewController: UIViewController, album: AlbumModel) {
        let presenter = AlbumPresenter(album: album)
        let albumViewController = AlbumViewController(presenter: presenter)
        presenter.viewController = albumViewController
        viewController.navigationController?.pushViewController(albumViewController, animated: true)
    }
    
    func showReportFrom(_ viewController: UIViewController, podcast: PodcastModel) {
        let presenter = ReportPresenter(podcast: podcast)
        let reportViewController = ReportViewController(presenter: presenter)
        presenter.viewController = reportViewController
        viewController.navigationController?.pushViewController(reportViewController, animated: true)
    }
}
