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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension AlbumsViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    func createAlbum() {
        
    }
}

extension AlbumsViewController: UITableViewDelegate {
    
}

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10 //заменить на датасорс
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumViewCell.reuseIdentifier, for: indexPath)
                       
        guard let albumCell = cell as? AlbumViewCell else {
           return UITableViewCell()
        }
        
        albumCell.config(text: "Альбом \(indexPath.row)")

        return albumCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

