import UIKit


final class AlbumsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.register(AlbumViewCell.self, forCellReuseIdentifier: AlbumViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let presenter: AlbumsPresenter
    private var albums: [String] = []
    
    private var lastSelect: IndexPath? {
        if let index = presenter.selectedAlbumIndex() {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    init(presenter: AlbumsPresenter) {
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.closeViewController()
    }
    
    func config(_ albums: [String]) {
        self.albums = albums
        tableView.reloadData()
    }
    
    func exit() {
        dismiss(animated: true)
    }
}

private extension AlbumsViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        presenter.getInfo()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.title = "Альбомы"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Создать", style: .done, target: self, action: #selector(Self.createAlbum))
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
    
    @objc
    func createAlbum() {
        presenter.create()
    }
}

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexes = [indexPath]
        if let lastSelect {
            indexes.append(lastSelect)
        }
        presenter.selectedAlbum(index: indexPath.row)
        tableView.reloadRows(at: indexes, with: .automatic)
    }
}

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumViewCell.reuseIdentifier, for: indexPath)
                       
        guard let albumCell = cell as? AlbumViewCell else {
           return UITableViewCell()
        }
        
        let selectedIndex = presenter.selectedAlbumIndex()
        var isSelected: Bool = false
        if let selectedIndex {
            isSelected = indexPath.row == selectedIndex
        }
        
        albumCell.config(text: albums[indexPath.row], isSelected: isSelected)

        if indexPath.row == albums.count - 1 {
            albumCell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
        }
        
        return albumCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = .zero
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
}

