import UIKit


final class AuthorProfileViewController: UIViewController {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var subButton: BaseButtonView = {
        let button = BaseButtonView()
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.register(PodcastViewCell.self, forCellReuseIdentifier: PodcastViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let presenter: AuthorPresenter
    private var albums: [Album] = []
    
    init(presenter: AuthorPresenter) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }
    
    func config(author: Author) {
        albums = author.albums
        nameLabel.text = author.name
        avatarImageView.kf.setImage(with: author.avatarUrl, placeholder: UIImage(named: "Logo"))
        if author.isSubscribe {
            subButton.config(text: "Отписаться", backgroundColor: UIColor(named: "ButtonGray") ?? .gray, animated: true)
        } else {
            subButton.config(text: "Подписаться", backgroundColor: UIColor(named: "Subscribe") ?? .red, animated: true)
        }
    }
}

private extension AuthorProfileViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
        presenter.getInfo()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    func addSubviews() {
        [nameLabel,
         avatarImageView,
         subButton,
         tableView
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
            subButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 40),
            subButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            subButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            subButton.heightAnchor.constraint(equalToConstant: 50),
            tableView.topAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor),
            tableView.topAnchor.constraint(equalTo: subButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func addActions() {
        subButton.addTarget(self, action: #selector(Self.didTapSubButton), for: .touchUpInside)
    }
    
    @objc
    func didTapSubButton() {
        presenter.subscribe()
    }
}

extension AuthorProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showPodcast(indexPath: indexPath)
    }
}

extension AuthorProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        albums[section].name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else {
            return
        }
        
        headerView.textLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        headerView.layer.masksToBounds = true
        headerView.backgroundView?.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums[section].podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PodcastViewCell.reuseIdentifier, for: indexPath)
                       
        guard let podcastCell = cell as? PodcastViewCell else {
           return UITableViewCell()
        }
        let podcast = albums[indexPath.row].podcasts[indexPath.row]
        if let url = podcast.logoUrl {
            podcastCell.config(podcast: podcast, separator: indexPath.row != albums[indexPath.section].podcasts.count - 1)
        }
        
        return podcastCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
