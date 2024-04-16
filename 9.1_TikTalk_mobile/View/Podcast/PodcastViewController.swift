import UIKit


final class PodcastViewController: UIViewController {
    
    private lazy var podcastView: PodcastView = {
        let podcastView = PodcastView()
        podcastView.translatesAutoresizingMaskIntoConstraints = false
        return podcastView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension PodcastViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    func addSubviews() {
        view.addSubview(podcastView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            podcastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            podcastView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            podcastView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            podcastView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
