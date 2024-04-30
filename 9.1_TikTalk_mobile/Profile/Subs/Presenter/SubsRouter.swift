import UIKit


final class SubsRouter {
    
    func showAuthorFrom(_ viewController: UIViewController, author: AuthorModel) {
        let presenter = AuthorPresenter(author: author)
        let authorViewController = AuthorProfileViewController(presenter: presenter)
        presenter.viewController = authorViewController
        viewController.navigationController?.pushViewController(authorViewController, animated: true)
    }
}
