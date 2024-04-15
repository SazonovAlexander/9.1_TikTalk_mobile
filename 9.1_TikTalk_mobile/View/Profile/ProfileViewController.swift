import UIKit


final class ProfileViewController: UIViewController {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "Имя профиля" //имя профиля
        label.textAlignment = .center
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var changeProfileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "ProfileButtonBackgorund")
        button.setTitle("Редактировать профиль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var createPodcastButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "ProfileButtonBackgorund")
        button.setTitle("Создать подкаст", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var subsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "ProfileButtonBackgorund")
        button.setTitle("Подписки", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "ProfileButtonBackgorund")
        button.setTitle("Понравившееся", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var myPodcastsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "ProfileButtonBackgorund")
        button.setTitle("Мои подкасты", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            changeProfileButton,
            createPodcastButton,
            subsButton,
            likeButton,
            myPodcastsButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }
}

private extension ProfileViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    func addSubviews() {
        [nameLabel,
        stackView,
        avatarImageView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            stackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            changeProfileButton.heightAnchor.constraint(equalToConstant: 50),
            createPodcastButton.heightAnchor.constraint(equalToConstant: 50),
            subsButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            myPodcastsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
