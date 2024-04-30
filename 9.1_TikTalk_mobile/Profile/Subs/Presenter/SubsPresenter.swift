import Foundation


final class SubsPresenter {
    weak var viewController: SubsViewController?
    
    private let authorService: AuthorService
    private let router: SubsRouter
    private var profile: ProfileModel
    private lazy var authors: [AuthorModel] = {
        profile.subscriptions.map{authorService.getAuthorById($0)}
    }()
    
    init(profile: ProfileModel,
         authorService: AuthorService = AuthorService(),
         subsRouter: SubsRouter = SubsRouter()
    ) {
        self.profile = profile
        self.authorService = authorService
        self.router = subsRouter
    }
    
    func showAuthor(index: Int) {
        if let viewController {
            router.showAuthorFrom(viewController, author: authors[index])
        }
    }
    
    func getInfo() {
        var authorsView: [AuthorCell] = []
        authors.forEach {
            if let url = URL(string: $0.avatarUrl) {
                authorsView.append(AuthorCell(name: $0.name, avatarUrl: url))
            }
        }
        viewController?.config(authors: authorsView)
    }
}
