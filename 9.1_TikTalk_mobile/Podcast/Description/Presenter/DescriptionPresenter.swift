import Foundation


final class DescriptionPresenter {
    
    weak var viewController: DescriptionViewController?
    private var description: Description {
        didSet {
            getDescription()
        }
    }
    
    init(description: Description) {
        self.description = description
    }
    
    func getDescription() {
        viewController?.config(description)
    }
}
