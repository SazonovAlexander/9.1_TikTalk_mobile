import UIKit


final class BandViewController: UIViewController {
    
    private lazy var bandTypeSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: [BandType.all.rawValue, BandType.subscriptions.rawValue])
        segment.selectedSegmentIndex = 0
        segment.selectedSegmentTintColor = .white
        segment.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white],
            for:.normal
        )
        segment.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.black],
            for:.selected
        )
        return segment
    }()
    
    private lazy var podcastView: PodcastView = {
        let podcastView = PodcastView()
        podcastView.delegate = self
        return podcastView
    }()
    
    private lazy var newPodcastView: PodcastView = {
        let podcastView = PodcastView()
        return podcastView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.isScrollEnabled = false
        return scroll
    }()
    
    private lazy var autoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 1
        label.text = "Автопереход"
        return label
    }()
    
    private lazy var autoSwitch: UISwitch = {
        let autoSwitch = UISwitch()
        autoSwitch.onTintColor = .blue
        return autoSwitch
    }()
    
    private lazy var swipeRight: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(Self.handleSwipeRight(_:)))
        swipe.direction = .right
        return swipe
    }()
    
    private lazy var swipeLeft: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(Self.handleSwipeLeft(_:)))
        swipe.direction = .left
        return swipe
    }()
    
    private lazy var rightNewPodcastConstraints = [
        podcastView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        podcastView.trailingAnchor.constraint(equalTo: newPodcastView.leadingAnchor),
    ]
    
    private lazy var leftNewPodcastConstraints = [
        podcastView.leadingAnchor.constraint(equalTo: newPodcastView.trailingAnchor),
        newPodcastView.trailingAnchor.constraint(equalTo: scrollView.leadingAnchor),
    ]

    private var bandPresenter: BandPresenter
    
    init(bandPresenter: BandPresenter) {
        self.bandPresenter = bandPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAuthController()
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        podcastView.stopPlayer()
    }
    
    func config(podcast: Podcast, animation: BandAnimation) {
        self.podcastView.stopPlayer()
        if animation == .none {
            podcastView.config(podcast: podcast)
            podcastView.startPlayer()
        } else if animation == .rigth {
            NSLayoutConstraint.deactivate(leftNewPodcastConstraints)
            NSLayoutConstraint.activate(rightNewPodcastConstraints)
            newPodcastView.config(podcast: podcast)
            UIView.animate(withDuration: 0.75, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.podcastView.frame.width, y: 0)
            }, completion: { completed in
                if completed {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                    self.podcastView.config(podcast: podcast)
                    self.podcastView.startPlayer()
                }
            })
        } else if animation == .left {
            NSLayoutConstraint.deactivate(rightNewPodcastConstraints)
            NSLayoutConstraint.activate(leftNewPodcastConstraints)
            newPodcastView.config(podcast: podcast)
            UIView.animate(withDuration: 0.75, animations: {
                self.scrollView.contentOffset = CGPoint(x: -self.podcastView.frame.width, y: 0)
            }, completion: { completed in
                if completed {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                    self.podcastView.config(podcast: podcast)
                    self.podcastView.startPlayer()
                }
            })
        } else if animation == .empty {
            podcastView.config(podcast: podcast)
        }
    }
}

private extension BandViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
        bandPresenter.updateBand(Band(type: bandTypeSegment.selectedSegmentIndex == 0 ? .all : .subscriptions, auto: autoSwitch.isOn))
        podcastView.addPlayerHandeler { [weak self] in
            if let auto = self?.bandPresenter.band?.auto {
                if auto {
                    self?.bandPresenter.getNextPodcast()
                }
            }
        }
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func addSubviews() {
        [bandTypeSegment,
         scrollView,
         autoLabel,
         autoSwitch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [podcastView,
         newPodcastView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            bandTypeSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            bandTypeSegment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bandTypeSegment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: bandTypeSegment.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 2),
            podcastView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            podcastView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            newPodcastView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            newPodcastView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: autoSwitch.topAnchor, constant: -10),
            podcastView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            podcastView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            newPodcastView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            newPodcastView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            autoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            autoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            autoSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            autoSwitch.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate(rightNewPodcastConstraints)
    }
    
    func addActions() {
        autoSwitch.addTarget(self, action: #selector(Self.didBandChange), for: .valueChanged)
        bandTypeSegment.addTarget(self, action: #selector(Self.didBandChange), for: .valueChanged)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc
    func didBandChange() {
        let band = Band(type: bandTypeSegment.selectedSegmentIndex == 0 ? .all : .subscriptions, auto: autoSwitch.isOn)
        bandPresenter.updateBand(band)
    }
    
    @objc 
    func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
       if gesture.state == .ended {
           bandPresenter.getPrevPodcast()
       }
   }
    
    @objc 
    func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            bandPresenter.getNextPodcast()
        }
    }
}

extension BandViewController: PodcastDelegate {
    
    func tapLikeButton() {
        bandPresenter.liked()
    }
    
    func tapAuthorButton() {
        bandPresenter.author()
    }
    
    func tapDescriptionButton() {
        bandPresenter.description()
    }
    
    func tapReportButton() {
        bandPresenter.report()
    }
    
    func tapAlbumButton() {
        bandPresenter.album()
    }
}

