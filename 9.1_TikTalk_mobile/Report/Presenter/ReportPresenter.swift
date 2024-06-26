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
        authorService.getAuthorById(podcast.authorId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let author):
                viewController?.config(authorName: author.name, podcastName: podcast.name, theme: selectedTheme)
            case .failure(_):
                viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение", completion: { [weak self] in
                    self?.viewController?.exit()
                })
            }
        }
    }
    
    func selectTheme() {
        if let viewController {
            reportRouter.showSelectThemeViewControllerFrom(
                viewController,
                themes: [
                    "Жестокие высказывания",
                    "Оскорбления",
                    "Призыв к опасным действиям",
                    "Ложная информация",
                    "Пропаганда терроризма",
                    "Нарушение законодательства",
                    "Мошенничество",
                    "Другая тема"
                ],
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
        reportService.report(reportModel) { [weak self] result in
            switch result {
            case .success(_):
                if let viewController = self?.viewController {
                    self?.reportRouter.dismissReportViewController(viewController)
                }
            case .failure(_):
                self?.viewController?.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
            }
        }
    }
}
