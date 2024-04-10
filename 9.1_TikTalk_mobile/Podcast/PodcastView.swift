import UIKit


final class PodcastView: UIView {
    
    private let symbolButtonStackConfiguration = UIImage.SymbolConfiguration(pointSize: 44)
    private let symbolPlayerButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
    private lazy var playImage = UIImage(systemName: "pause.circle.fill", withConfiguration: symbolPlayerButtonConfiguration)
    private lazy var stopImage = UIImage(systemName: "play.fill", withConfiguration: symbolPlayerButtonConfiguration)
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: .logo)
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private lazy var authorButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.crop.circle", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private lazy var albumButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "menucard.fill", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private lazy var descriptionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.justify", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "flag.fill", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            likeButton,
            authorButton,
            albumButton,
            descriptionButton,
            reportButton
        ])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var countLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.text = "100" //прописать сокращения
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 1
        label.text = "Подкаст" // название + альбом
        return label
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 1
        label.text = "Автор" //имя автора
        return label
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
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

private extension PodcastView {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        backgroundColor = .clear
    }
    
    func addSubviews() {
        [logoImageView,
        buttonStack,
        countLikeLabel,
        nameLabel,
        authorNameLabel,
        slider,
        playerButton,
        currentTime,
        totalTime].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            buttonStack.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            countLikeLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor),
            countLikeLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: countLikeLabel.bottomAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            authorNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            slider.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 15),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            playerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playerButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
            currentTime.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5),
            currentTime.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
            totalTime.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5),
            totalTime.trailingAnchor.constraint(equalTo: slider.trailingAnchor)
        ])
    }
}
