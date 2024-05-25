import Foundation


final class ReportPresenter {
    
    weak var viewController: ReportViewController?
    
    private var podcast: PodcastModel
    private let reportRouter: ReportRouter
    private let reportService: ReportService
    private let authorService: AuthorService
    private var selectedTheme: String? {
        didSet {
            getInfo()
        }
    }
    
    init(podcast: PodcastModel,
         reportRouter: ReportRouter = ReportRouter(),
         reportService: ReportService = ReportService(),
         authorService: AuthorService = AuthorService()
    ) {
        self.podcast = podcast
        self.reportRouter = reportRouter
        self.reportService = reportService
        self.authorService = authorService
    }
    
    func getInfo() {
        if let author = getAuthor() {
            viewController?.config(authorName: author.name, podcastName: podcast.name, theme: selectedTheme)
        }
    }
    
    private func getAuthor() -> AuthorModel? {
        var authorModel: AuthorModel? = nil
        var errorMessage = ""
        authorService.getAuthorById(podcast.authorId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let author):
                authorModel = author
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
        
        if let authorModel {
            return authorModel
        } else {
            viewController?.showErrorAlert(title: "Ошибка", message: errorMessage, completion: { [weak self] in
                self?.viewController?.exit()
            })
            return nil
        }
    }
    
    func selectTheme() {
        if let viewController {
            reportRouter.showSelectThemeViewControllerFrom(
                viewController,
                themes: reportService.getReportThemes(),
                selectedTheme: selectedTheme,
                completion: { [weak self] theme in
                    self?.selectedTheme = theme
                }
            )
        }
    }
    
    func sendReport(_ report: Report) {
        let reportModel = ReportModel(
            podcastId: podcast.id,
            theme: report.theme,
            message: report.message
        )
        reportService.sendReport(reportModel)
        if let viewController {
            reportRouter.dismissReportViewController(viewController)
        }
    }
}
