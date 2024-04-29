import UIKit


final class SelectThemeViewController: UIViewController {
    
    private var presenter: SelectThemePresenter
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ThemeReportViewCell.self, forCellReuseIdentifier: ThemeReportViewCell.reuseIdentifier)
        return tableView
    }()
    
    private var lastSelect: IndexPath? {
        if let index = presenter.selectedThemeIndex() {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    init(presenter: SelectThemePresenter) {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.closeViewController()
    }
}

private extension SelectThemeViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.title = "Темы жалоб"
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

extension SelectThemeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexes = [indexPath]
        if let lastSelect {
            indexes.append(lastSelect)
        }
        presenter.selectedTheme(presenter.getThemes()[indexPath.row])
        tableView.reloadRows(at: indexes, with: .automatic)
    }
}

extension SelectThemeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getThemes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ThemeReportViewCell.reuseIdentifier, for: indexPath)
                       
        guard let themeCell = cell as? ThemeReportViewCell else {
           return UITableViewCell()
        }
        
        if indexPath.row == presenter.getThemes().count - 1 {
            themeCell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
        }
        let selectedIndex = presenter.selectedThemeIndex()
        var isSelected: Bool = false
        if let selectedIndex {
            isSelected = indexPath.row == selectedIndex
        }
        themeCell.config(text: presenter.getThemes()[indexPath.row], isSelected: isSelected)

        return themeCell
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
