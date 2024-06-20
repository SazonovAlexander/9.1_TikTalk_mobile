import UIKit
import Kingfisher


final class ProfileViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var changeProfileButton: UIButton = {
        let button = BaseButtonView()
        button.config(text: "Редактировать профиль", backgroundColor: UIColor(named: "ProfileButtonBackgorund") ?? .blue)
        return button
    }()
    
    private lazy var createPodcastButton: UIButton = {
        let button = BaseButtonView()
        button.config(text: "Создать подкаст", backgroundColor: UIColor(named: "ProfileButtonBackgorund") ?? .blue)
        return button
    }()
    
    private lazy var subsButton: UIButton = {
        let button = BaseButtonView()
        button.config(text: "Подписки", backgroundColor: UIColor(named: "ProfileButtonBackgorund") ?? .blue)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = BaseButtonView()
        button.config(text: "Понравившиеся", backgroundColor: UIColor(named: "ProfileButtonBackgorund") ?? .blue)
        return button
    }()
    
    private lazy var myPodcastsButton: UIButton = {
        let button = BaseButtonView()
        button.config(text: "Мои подкасты", backgroundColor: UIColor(named: "ProfileButtonBackgorund") ?? .blue)
        return button
    }()
    
    private lazy var exitButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Выйти", backgroundColor: UIColor(named: "ButtonRed") ?? .red)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            changeProfileButton,
            createPodcastButton,
            subsButton,
            likeButton,
            myPodcastsButton,
            exitButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        return stackView
    }()
    
    private let presenter: ProfilePresenter
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }
    
    func config(profile: Profile) {
        nameLabel.text = profile.name
        avatarImageView.kf.setImage(with: profile.avatarUrl, placeholder: UIImage(systemName: "person.circle.fill"))
    }
}

private extension ProfileViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.backButtonTitle = "Профиль"
    }
    
    func addSubviews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [nameLabel,
        stackView,
        avatarImageView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.superview?.bottomAnchor ?? view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            stackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            changeProfileButton.heightAnchor.constraint(equalToConstant: 50),
            createPodcastButton.heightAnchor.constraint(equalToConstant: 50),
            subsButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            myPodcastsButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func addActions() {
        changeProfileButton.addTarget(self, action: #selector(Self.didTapChangeButton), for: .touchUpInside)
        createPodcastButton.addTarget(self, action: #selector(Self.didTapCreateButton), for: .touchUpInside)
        subsButton.addTarget(self, action: #selector(Self.didTapSubsButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(Self.didTapLikeButton), for: .touchUpInside)
        myPodcastsButton.addTarget(self, action: #selector(Self.didTapMyPodcastsButton), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(Self.didTapExitButton), for: .touchUpInside)
    }
    
    @objc
    func didTapChangeButton() {
        presenter.changeProfile()
    }
    
    @objc
    func didTapCreateButton() {
        presenter.createPodcast()
    }
    
    @objc
    func didTapSubsButton() {
        presenter.subs()
    }
    
    @objc
    func didTapLikeButton() {
        presenter.like()
    }
    
    @objc
    func didTapMyPodcastsButton() {
        presenter.myPodcasts()
    }
    
    @objc
    func didTapExitButton() {
        presenter.exit()
    }
}
