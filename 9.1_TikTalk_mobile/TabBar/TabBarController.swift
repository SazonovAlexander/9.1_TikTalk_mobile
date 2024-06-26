import UIKit


final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TabBarController {
    
    func setup() {
        tabBar.barTintColor = .lightGray
        tabBar.tintColor = .white
        tabBar.standardAppearance = UITabBarAppearance(barAppearance: UIBarAppearance(idiom: .phone))
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        delegate = self
        
        let bandPresenter = BandPresenter()
        let bandViewController = BandViewController(bandPresenter: bandPresenter)
        bandPresenter.viewController = bandViewController
        let nav = UINavigationController(rootViewController: bandViewController)
        nav.navigationBar.backItem?.title = "Назад"
        nav.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "mic.fill"),
            selectedImage: nil
        )
        
        let searchPresenter = SearchPresenter()
        let searchViewController = SearchViewController(presenter: searchPresenter)
        searchPresenter.viewController = searchViewController
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.navigationBar.backItem?.title = "Назад"
        searchNavController.tabBarItem = UITabBarItem(
            title: "Поиск",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: nil
        )
        
        let profilePresenter = ProfilePresenter()
        let profileViewController = ProfileViewController(presenter: profilePresenter)
        profilePresenter.viewController = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.fill"),
            selectedImage: nil
        )
   
        self.viewControllers = [
            nav,
            searchNavController,
            profileViewController
        ]
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ProfileViewController {
            if TokenStorage.shared.accessToken == "" {
                showAuthController()
                return false
            }
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is SearchViewController {
            Analytic.shared.report(event: .open, screen: .search)
        }
    }
}
