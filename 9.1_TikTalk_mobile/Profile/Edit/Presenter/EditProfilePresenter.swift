import Foundation


final class EditProfilePresenter {
    
    weak var viewController: EditProfileViewController?
    
    private var profile: ProfileModel
    private var profileService: ProfileService
    private var imageUrl: String
    
    init(profile: ProfileModel, profileService: ProfileService = ProfileService()) {
        self.profile = profile
        self.profileService = profileService
        self.imageUrl = profile.avatarUrl ?? "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060"
    }
    
    func getInfo() {
        if let url = URL(string: profile.avatarUrl ?? "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060") {
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
            profileService.changeAvatar(profile: profileModel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    profileService.changeProfileName(profile: profileModel) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(_):
                            self.viewController?.exit()
                        case .failure(let error):
                            self.viewController?.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
                        }
                    }
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
            profileService.changeProfileName(profile: profileModel) { [weak self] result in
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
