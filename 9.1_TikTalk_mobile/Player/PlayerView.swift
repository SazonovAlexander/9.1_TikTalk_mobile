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
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var currentTime: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var totalTime: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private var isPlayed: Bool = true {
        didSet {
            playerButton.setImage(self.isPlayed ? playImage : stopImage, for: .normal)
        }
    }
    
    private let player: Player
    
    init(player: Player) {
        self.player = player
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTime(currentTime: String, totalTime: String, sliderValue: Double, maxValue: Double) {
        self.currentTime.text = currentTime
        self.totalTime.text = totalTime
        self.slider.value = Float(sliderValue)
        self.slider.maximumValue = Float(maxValue)
    }
}

private extension PlayerView {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
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
            heightAnchor.constraint(equalToConstant: 125),
        ])
    }
    
    func addActions() {
        playerButton.addTarget(self, action: #selector(Self.didTapPlayButton), for: .touchUpInside)
        slider.addTarget(self, action: #selector(Self.changedSliderValue), for: [.touchUpInside, .touchUpOutside])
        slider.addTarget(self, action: #selector(Self.startChangeValue), for: .touchDown)
    }
    
    @objc
    func didTapPlayButton() {
        if isPlayed {
            player.stop()
        } else {
            player.play()
        }
        isPlayed.toggle()
    }
    
    @objc
    func changedSliderValue() {
        player.updateValue(slider.value)
        if isPlayed {
            player.play()
        }
    }
    
    @objc
    func startChangeValue() {
        player.stop()
    }
    
}

