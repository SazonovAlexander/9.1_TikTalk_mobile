import UIKit


final class LikedPodcastsViewController: UIViewController {
    
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
    
    private let presenter: LikedPresenter
    private var podcasts: [PodcastCell] = []
    
    init(presenter: LikedPresenter) {
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
    
    func config(podcasts: [PodcastCell]) {
        self.podcasts = podcasts
        tableView.reloadData()
    }
}

private extension LikedPodcastsViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        presenter.getInfo()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.title = "Понравившееся"
    }
    
    func addSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension LikedPodcastsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showPodcast(index: indexPath.row)
    }
}

extension LikedPodcastsViewController: UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = .zero
        return headerView
    }
}
