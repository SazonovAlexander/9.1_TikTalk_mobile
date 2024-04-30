import UIKit


final class MyPodcastViewController: UIViewController {
    
    private let symbolButtonStackConfiguration = UIImage.SymbolConfiguration(pointSize: 44)
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = UIColor(named: "ButtonRed")
        return button
    }()
    
    private lazy var descriptionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.justify", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            likeButton,
            descriptionButton
        ])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    private lazy var countLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var player = Player()
    private lazy var playerView = PlayerView(player: player)
    
    private lazy var editButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Редактировать", backgroundColor: UIColor(named: "ProfileButtonBackgorund") ?? .blue)
        return button
    }()
    
    private lazy var deleteButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Удалить", backgroundColor: UIColor(named: "ButtonRed") ?? .red)
        return button
    }()
    
    private let presenter: MyPodcastPresenter
    
    init(presenter: MyPodcastPresenter) {
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
        player.setAudioFromUrl(podcast.audioUrl)
        logoImageView.kf.setImage(with: podcast.logoUrl, placeholder: UIImage(named: "Logo"))
        countLikeLabel.text = podcast.countLike
        nameLabel.text = podcast.name
    }
    
    func showConfirmAlert() {
        let alert = UIAlertController(title: "Подтвердите удаление", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            self?.presenter.confirmedDelete()
        }))
        present(alert, animated: true)
    }
    
    func exit() {
        dismiss(animated: true)
    }
}

private extension MyPodcastViewController {
    
    func setup() {
        player.playerView = playerView
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
        presenter.getPodcast()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    func addSubviews() {
        [logoImageView,
        buttonStack,
        countLikeLabel,
        nameLabel,
        playerView,
        editButton,
        deleteButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            logoImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStack.topAnchor.constraint(greaterThanOrEqualTo: logoImageView.bottomAnchor, constant: 30),
            buttonStack.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            countLikeLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor),
            countLikeLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: buttonStack.centerYAnchor),
            playerView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 15),
            playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            editButton.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 20),
            editButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            deleteButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func addActions() {
        descriptionButton.addTarget(self, action: #selector(Self.didTapDescriptionButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(Self.didTapDeleteButton), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(Self.didTapEditButton), for: .touchUpInside)
    }
    
    @objc
    func didTapDescriptionButton() {
        presenter.description()
    }
    
    @objc
    func didTapDeleteButton() {
        presenter.delete()
    }
    
    @objc
    func didTapEditButton() {
        presenter.edit()
    }
}


