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
        
        let bandViewController = BandViewController()
        let nav = UINavigationController(rootViewController: bandViewController)
        nav.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "mic.fill"),
            selectedImage: nil
        )
        let presenter = PodcastPresenter(podcast: Mocks.podcast)
        let albumViewController = PodcastViewController(presenter: presenter)
        presenter.viewController = albumViewController
        let nc = UINavigationController(rootViewController: albumViewController)
        nc.tabBarItem = UITabBarItem(
            title: "Поиск",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.fill"),
            selectedImage: nil
        )
   
        self.viewControllers = [
            nav,
            nc,
            profileViewController
        ]
    }
}
