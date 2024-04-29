import UIKit


final class ReportRouter {
    
    func showSelectThemeViewControllerFrom(_ viewController: UIViewController, themes: [String], selectedTheme: String?, completion: @escaping (String) -> Void) {
        let presenter = SelectThemePresenter(themes: themes, selectedTheme: selectedTheme, completion: completion)
        let selectThemeViewController = SelectThemeViewController(presenter: presenter)
        viewController.navigationController?.pushViewController(selectThemeViewController, animated: true)
    }
    
    func dismissReportViewController(_ viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
}
