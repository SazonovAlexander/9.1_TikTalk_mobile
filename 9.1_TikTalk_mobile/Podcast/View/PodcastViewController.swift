import UIKit


final class PodcastViewController: UIViewController {
    
    private lazy var podcastView: PodcastView = {
        let podcastView = PodcastView()
        podcastView.translatesAutoresizingMaskIntoConstraints = false
        return podcastView
    }()
    
    private let presenter: PodcastPresenter
    
    init(presenter: PodcastPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func config(podcast: Podcast) {
        podcastView.config(podcast: podcast)
    }
}

private extension PodcastViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        presenter.getPodcast()
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

extension PodcastViewController: PodcastDelegate {
    
    func tapLikeButton() {
        presenter.liked()
    }
    
    func tapAuthorButton() {
        presenter.author()
    }
    
    func tapDescriptionButton() {
        presenter.description()
    }
    
    func tapReportButton() {
        presenter.report()
    }
    
    func tapAlbumButton() {
        presenter.album()
    }
}
