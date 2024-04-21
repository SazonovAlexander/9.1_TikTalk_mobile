import UIKit


final class PlayerView: UIView {
    
    private let symbolPlayerButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
    
    private lazy var playImage = UIImage(systemName: "pause.circle.fill", withConfiguration: symbolPlayerButtonConfiguration)
    
    private lazy var stopImage = UIImage(systemName: "play.fill", withConfiguration: symbolPlayerButtonConfiguration)
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .white
        return slider
    }()
    
    private lazy var playerButton: UIButton = {
        let button = UIButton()
        button.setImage(playImage, for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private lazy var currentTime: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        label.text = "0:45" //текущее время
        return label
    }()
    
    private lazy var totalTime: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        label.text = "2:10" //полное время
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PlayerView {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        backgroundColor = .clear
    }
    
    func addSubviews() {
        [slider,
        playerButton,
        currentTime,
        totalTime].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            slider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            playerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playerButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
            currentTime.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5),
            currentTime.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
            totalTime.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5),
            totalTime.trailingAnchor.constraint(equalTo: slider.trailingAnchor),
            playerButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

