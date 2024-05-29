import Foundation


final class SubsPresenter {
    weak var viewController: SubsViewController?
    
    private let authorService: AuthorService
    private let router: SubsRouter
    private var profile: ProfileModel
    private lazy var authors: [AuthorModel] = {
        var authors: [AuthorModel] = []
        var success = true
        var errorMessage = ""
        profile.subscriptions.forEach {
            authorService.getAuthorById($0) { [weak self] result in
                switch result {
                case .success(let author):
                    authors.append(author)
                case .failure(let error):
                    success = false
                    errorMessage = error.localizedDescription
                }
            }
        }
        
        if success {
            return authors
        } else {
            self.viewController?.showErrorAlert(title: "Ошибка", message: errorMessage, completion: { [weak self] in
                self?.viewController?.exit()
            })
            return []
        }
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
