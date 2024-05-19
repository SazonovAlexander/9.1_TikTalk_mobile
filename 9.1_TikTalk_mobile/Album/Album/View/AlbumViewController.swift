import UIKit


final class AlbumViewController: UIViewController {
    
    private let symbolButtonStackConfiguration = UIImage.SymbolConfiguration(pointSize: 44)
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var authorButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.crop.circle", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private lazy var descriptionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.justify", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorButton, descriptionButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "Подкасты"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.register(PodcastViewCell.self, forCellReuseIdentifier: PodcastViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let presenter: AlbumPresenter
    private var podcasts: [PodcastCell] = []
    
    init(presenter: AlbumPresenter) {
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
    
    func config(name: String) {
        nameLabel.text = name
    }
}

private extension AlbumViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
        podcasts = presenter.getPodcasts()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.backButtonTitle = "Альбом"
    }
    
    func addSubviews() {
        [nameLabel,
        stackView,
        titleLabel,
        tableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func addActions() {
        descriptionButton.addTarget(self, action: #selector(Self.didTapDescriptionButton), for: .touchUpInside)
        authorButton.addTarget(self, action: #selector(Self.didTapAuthorButton), for: .touchUpInside)
    }
    
    @objc
    func didTapDescriptionButton() {
        presenter.showDescription()
    }
    
    @objc
    func didTapAuthorButton() {
        presenter.showAuthor()
    }
}

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showPodcast(index: indexPath.row)
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PodcastViewCell.reuseIdentifier, for: indexPath)
                       
        guard let podcastCell = cell as? PodcastViewCell else {
           return UITableViewCell()
        }
        
        podcastCell.config(podcast: podcasts[indexPath.row])

        return podcastCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
