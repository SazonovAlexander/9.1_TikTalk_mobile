import UIKit


final class SearchViewController: UIViewController {
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Введите название подкаста"
        return searchTextField
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
    
    private let presenter: SearchPresenter
    private var podcasts: [PodcastCell] = []
    
    init(presenter: SearchPresenter) {
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
    
    func update(podcasts: [PodcastCell]) {
        self.podcasts = podcasts
        tableView.reloadData()
    }
}

private extension SearchViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
        hideKeyboardWhenTappedAround()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    func addSubviews() {
        [searchTextField,
         tableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func addActions() {
        searchTextField.addTarget(self, action: #selector(Self.searchTextUpdate), for: .allEditingEvents)
    }
    
    @objc
    func searchTextUpdate() {
        presenter.search(searchTextField.text ?? "")
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showPodcast(index: indexPath.row)
    }
}

extension SearchViewController: UITableViewDataSource {
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
            podcastCell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
        }

        return podcastCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
