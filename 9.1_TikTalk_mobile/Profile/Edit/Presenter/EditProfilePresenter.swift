import Foundation


final class EditProfilePresenter {
    
    weak var viewController: EditProfileViewController?
    
    private var profile: ProfileModel
    private var profileService: ProfileService
    
    init(profile: ProfileModel, profileService: ProfileService = ProfileService()) {
        self.profile = profile
        self.profileService = profileService
    }
    
    func getInfo() {
        if let url = URL(string: profile.avatarUrl) {
            let profile = Profile(name: self.profile.name, avatarUrl: url)
            viewController?.config(profile: profile)
        }
    }
    
    func save() {
        viewController?.exit()
    }
}
