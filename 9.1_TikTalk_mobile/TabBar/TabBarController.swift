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
        
        
        let bandViewController = BandViewController()
        bandViewController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "mic.fill"),
            selectedImage: nil
        )
        
        let searchViewController = PodcastViewController() //временно здесь подкаст
        searchViewController.tabBarItem = UITabBarItem(
            title: "Поиск",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: nil
        )
        
        let profileViewController = PodcastViewController() //временно здесь подкаст
        profileViewController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.fill"),
            selectedImage: nil
        )
   
        self.viewControllers = [
            bandViewController,
            searchViewController,
            profileViewController
        ]
    }
}
