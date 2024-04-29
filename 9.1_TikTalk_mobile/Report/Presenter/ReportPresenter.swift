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
    private var author: AuthorModel {
        self.authorService.getAuthorById(podcast.authorId)
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
        viewController?.config(authorName: author.name, podcastName: podcast.name, theme: selectedTheme)
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
