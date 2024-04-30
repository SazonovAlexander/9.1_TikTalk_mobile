import UIKit


final class ProfileRouter {
    
    func showChangeProfileFrom(_ viewController: UIViewController, profile: ProfileModel) {
        
    }
    
    func showCreatePodcastFrom(_ viewController: UIViewController, profile: ProfileModel) {
        
    }
    
    func showSubsFrom(_ viewController: UIViewController, profile: ProfileModel) {
        let presenter = SubsPresenter(profile: profile)
        let subsViewController = SubsViewController(presenter: presenter)
        presenter.viewController = subsViewController
        let navController = UINavigationController(rootViewController: subsViewController)
        viewController.present(navController, animated: true)
    }
    
    func showLikeFrom(_ viewController: UIViewController, profile: ProfileModel) {
        let presenter = LikedPresenter(profile: profile)
        let likedViewController = LikedPodcastsViewController(presenter: presenter)
        presenter.viewController = likedViewController
        let navController = UINavigationController(rootViewController: likedViewController)
        viewController.present(navController, animated: true)
    }
    
    func showMyPodcastsFrom(_ viewController: UIViewController, profile: ProfileModel) {
        
    }
    
    func exit() {
        
    }
}
