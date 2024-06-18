import UIKit


final class ProfileRouter {
    
    func showChangeProfileFrom(_ viewController: UIViewController, profile: ProfileModel) {
        if TokenStorage.shared.accessToken == "" {
            viewController.showAuthController()
        } else {
            let presenter = EditProfilePresenter(profile: profile)
            let editProfileViewController = EditProfileViewController(presenter: presenter)
            presenter.viewController = editProfileViewController
            viewController.present(editProfileViewController, animated: true)
        }
    }
    
    func showCreatePodcastFrom(_ viewController: UIViewController) {
        if TokenStorage.shared.accessToken == "" {
            viewController.showAuthController()
        } else {
            let presenter = CreateEditPodcastPresenter()
            let createPodcast = CreateEditPodcastViewController(presenter: presenter)
            presenter.viewController = createPodcast
            let navController = UINavigationController(rootViewController: createPodcast)
            navController.navigationBar.backItem?.title = "Назад"
            viewController.present(navController, animated: true)
        }
    }
    
    func showSubsFrom(_ viewController: UIViewController, profile: ProfileModel) {
        if TokenStorage.shared.accessToken == "" {
            viewController.showAuthController()
        } else {
            let presenter = SubsPresenter(profile: profile)
            let subsViewController = SubsViewController(presenter: presenter)
            presenter.viewController = subsViewController
            let navController = UINavigationController(rootViewController: subsViewController)
            navController.navigationBar.backItem?.title = "Назад"
            viewController.present(navController, animated: true)
        }
    }
    
    func showLikeFrom(_ viewController: UIViewController, profile: ProfileModel) {
        if TokenStorage.shared.accessToken == "" {
            viewController.showAuthController()
        } else {
            let presenter = LikedPresenter(profile: profile)
            let likedViewController = LikedPodcastsViewController(presenter: presenter)
            presenter.viewController = likedViewController
            let navController = UINavigationController(rootViewController: likedViewController)
            navController.navigationBar.backItem?.title = "Назад"
            viewController.present(navController, animated: true)
        }
    }
    
    func showMyPodcastsFrom(_ viewController: UIViewController, profile: ProfileModel) {
        if TokenStorage.shared.accessToken == "" {
            viewController.showAuthController()
        } else {
            let presenter = MyPodcastsPresenter(profile: profile)
            let myPodcastsViewController = MyPodcastsViewController(presenter: presenter)
            presenter.viewController = myPodcastsViewController
            let navController = UINavigationController(rootViewController: myPodcastsViewController)
            navController.navigationBar.backItem?.title = "Назад"
            viewController.present(navController, animated: true)
        }
    }
    
    func exit() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}
