import Foundation


final class SubsPresenter {
    weak var viewController: SubsViewController?
    
    private let authorService: AuthorService
    private let router: SubsRouter
    private var profile: ProfileModel
    private lazy var authors: [AuthorModel] = [] {
        didSet {
            print(authors)
            getInfo()
        }
    }
    
    init(profile: ProfileModel,
         authorService: AuthorService = AuthorService(),
         subsRouter: SubsRouter = SubsRouter()
    ) {
        self.profile = profile
        self.authorService = authorService
        self.router = subsRouter
        getAuthors()
    }
    
    private func getAuthors() {
        let group = DispatchGroup()
        var authors: [AuthorModel] = []
        var success = true
        var errorMessage = ""
        profile.subscriptions.forEach {
            group.enter()
            print("getAuthor")
            if let id = UUID(uuidString: $0) {
                authorService.getAuthorById(id) {result in
                    switch result {
                    case .success(let author):
                        authors.append(author)
                        group.leave()
                    case .failure(let error):
                        success = false
                        errorMessage = error.localizedDescription
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main, execute: {
            if success {
                self.authors = authors
            } else {
                self.viewController?.showErrorAlert(title: "Ошибка", message: errorMessage, completion: { [weak self] in
                    self?.viewController?.exit()
                })
            }
        })
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
