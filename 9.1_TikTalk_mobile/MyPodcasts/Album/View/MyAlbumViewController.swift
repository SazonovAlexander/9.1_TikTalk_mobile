import UIKit


final class MyAlbumViewController: UIViewController {
    
    private let symbolButtonStackConfiguration = UIImage.SymbolConfiguration(pointSize: 44)
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descriptionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.justify", withConfiguration: symbolButtonStackConfiguration), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
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
        tableView.register(PodcastViewCell.self, forCellReuseIdentifier: PodcastViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let presenter: MyAlbumPresenter
    private var podcasts: [PodcastCell] = []
    
    init(presenter: MyAlbumPresenter) {
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
    
    func config(album: Album) {
        nameLabel.text = album.name
        podcasts = album.podcasts
        tableView.reloadData()
    }
    
    func showConfirmAlert() {
        let alert = UIAlertController(title: "Подтвердите удаление", message: "Все подкасты, находящиеся в альбоме, будут удалены!", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            self?.presenter.confirmedDelete()
        }))
        present(alert, animated: true)
    }
}

private extension MyAlbumViewController {
    
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
        descriptionButton,
        editButton,
        deleteButton,
        titleLabel,
        tableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            descriptionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: descriptionButton.leadingAnchor),
            descriptionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameLabel.centerYAnchor.constraint(equalTo: descriptionButton.centerYAnchor),
            editButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            editButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            deleteButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 20),
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

extension MyAlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.podcast(index: indexPath.row)
    }
}

extension MyAlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PodcastViewCell.reuseIdentifier, for: indexPath)
                       
        guard let podcastCell = cell as? PodcastViewCell else {
           return UITableViewCell()
        }
        
        podcastCell.config(podcast: podcasts[indexPath.row])
        
        if indexPath.row == podcasts.count - 1 {
            podcastCell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }

        return podcastCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
