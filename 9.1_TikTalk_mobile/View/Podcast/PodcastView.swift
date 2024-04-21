import UIKit


final class PodcastView: UIView {
    
    private let symbolButtonStackConfiguration = UIImage.SymbolConfiguration(pointSize: 44)
    private let symbolPlayerButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
    private lazy var playImage = UIImage(systemName: "pause.circle.fill", withConfiguration: symbolPlayerButtonConfiguration)
    private lazy var stopImage = UIImage(systemName: "play.fill", withConfiguration: symbolPlayerButtonConfiguration)
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
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
    
    private lazy var player = PlayerView()
    
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
        player
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            buttonStack.topAnchor.constraint(greaterThanOrEqualTo: logoImageView.bottomAnchor, constant: 30),
            buttonStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            countLikeLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor),
            countLikeLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: countLikeLabel.bottomAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            authorNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            player.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 15),
            player.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            player.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            player.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
