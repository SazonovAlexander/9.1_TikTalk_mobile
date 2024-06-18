import Foundation


final class ProfilePresenter {
    
    weak var viewController: ProfileViewController?
    
    private let profileService: ProfileService
    private let router: ProfileRouter
    private var profile: ProfileModel?
    
    init(profileService: ProfileService = ProfileService(),
         profileRouter: ProfileRouter = ProfileRouter()
    ) {
        self.profileService = profileService
        self.router = profileRouter
    }
    
    func getInfo() {
        profileService.getProfile {[weak self] result in
            switch result {
            case .success(let profileModel):
                self?.profile = profileModel
                if let url = URL(string: profileModel.avatarUrl ?? "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060") {
                    self?.viewController?.config(profile: Profile(name: profileModel.name, avatarUrl: url))
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    func changeProfile() {
        if let profile,  let viewController {
            router.showChangeProfileFrom(viewController, profile: profile)
        }
    }
    
    func createPodcast() {
        if let viewController {
            router.showCreatePodcastFrom(viewController)
        }
    }
    
    func subs() {
        if let profile, let viewController {
            router.showSubsFrom(viewController, profile: profile)
        }
    }
    
    func like() {
        if let profile, let viewController {
            router.showLikeFrom(viewController, profile: profile)
        }
    }
    
    func myPodcasts() {
        if let profile, let viewController {
            router.showMyPodcastsFrom(viewController, profile: profile)
        }
    }
    
    func exit() {
        TokenStorage.shared.accessToken = ""
        TokenStorage.shared.refreshToken = ""
        router.exit()
    }
}
