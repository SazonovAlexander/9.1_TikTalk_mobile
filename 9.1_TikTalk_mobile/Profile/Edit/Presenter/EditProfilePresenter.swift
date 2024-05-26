import Foundation


final class EditProfilePresenter {
    
    weak var viewController: EditProfileViewController?
    
    private var profile: ProfileModel
    private var profileService: ProfileService
    private var imageUrl: String
    
    init(profile: ProfileModel, profileService: ProfileService = ProfileService()) {
        self.profile = profile
        self.profileService = profileService
        self.imageUrl = profile.avatarUrl
    }
    
    func getInfo() {
        if let url = URL(string: profile.avatarUrl) {
            let profile = Profile(name: self.profile.name, avatarUrl: url)
            viewController?.config(profile: profile)
        }
    }
    
    func save(newName: String, newImageUrl: URL?) {
        if let newImageUrl {
            let profileModel = ProfileModel(
                name: newName,
                avatarUrl: newImageUrl.absoluteString,
                subscriptions: profile.subscriptions,
                liked: profile.liked,
                albums: profile.albums
            )
            profileService.changeProfileWithAvatar(profile: profileModel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    self.viewController?.exit()
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        } else {
            let profileModel = ProfileModel(
                name: newName,
                avatarUrl: profile.avatarUrl,
                subscriptions: profile.subscriptions,
                liked: profile.liked,
                albums: profile.albums
            )
            profileService.changeProfileWithoutAvatar(profile: profileModel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    self.viewController?.exit()
                case .failure(let error):
                    self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
}
