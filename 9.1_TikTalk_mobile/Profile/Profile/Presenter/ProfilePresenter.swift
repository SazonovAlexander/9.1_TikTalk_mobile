import Foundation


final class ProfilePresenter {
    
    weak var viewController: ProfileViewController?
    
    private var profile: ProfileModel
    private let profileService: ProfileService
    private let router: ProfileRouter
    
    init(profile: ProfileModel,
         profileService: ProfileService = ProfileService(),
         profileRouter: ProfileRouter = ProfileRouter()
    ) {
        self.profile = profile
        self.profileService = profileService
        self.router = profileRouter
    }
    
    func getInfo() {
        if let url = URL(string: profile.avatarUrl) {
            viewController?.config(profile: Profile(name: profile.name, avatarUrl: url))
        }
    }
    
    func changeProfile() {
        if let viewController {
            router.showChangeProfileFrom(viewController, profile: profile)
        }
    }
    
    func createPodcast() {
        if let viewController {
            router.showCreatePodcastFrom(viewController)
        }
    }
    
    func subs() {
        if let viewController {
            router.showSubsFrom(viewController, profile: profile)
        }
    }
    
    func like() {
        if let viewController {
            router.showLikeFrom(viewController, profile: profile)
        }
    }
    
    func myPodcasts() {
        if let viewController {
            router.showMyPodcastsFrom(viewController, profile: profile)
        }
    }
    
    func exit() {
        TokenStorage.shared.accessToken = ""
        TokenStorage.shared.refreshToken = ""
        router.exit()
    }
}
