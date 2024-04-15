import UIKit

enum BandType: String {
    case all = "Общая"
    case subscriptions = "Подписки"
}

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
        return podcastView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension BandViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    func addSubviews() {
        [bandTypeSegment,
         podcastView,
         autoLabel,
         autoSwitch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            bandTypeSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            bandTypeSegment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bandTypeSegment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            podcastView.topAnchor.constraint(equalTo: bandTypeSegment.bottomAnchor, constant: 20),
            podcastView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            podcastView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            podcastView.bottomAnchor.constraint(lessThanOrEqualTo: autoSwitch.topAnchor, constant: -10),
            autoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            autoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            autoSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            autoSwitch.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
}

