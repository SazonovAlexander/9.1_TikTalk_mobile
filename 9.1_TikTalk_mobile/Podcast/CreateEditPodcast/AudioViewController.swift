import UIKit


final class AudioViewController: UIViewController {
    
    private lazy var cutterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.text = "Обрезка" // название + альбом
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var cutterView = CutterView()
    
    private lazy var fileButton: UIButton = {
        let button = BaseButtonView()
        button.config(text: "Загрузить из файла", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
        return button
    }()
    
    private lazy var recordButton: UIButton = {
        let button = BaseButtonView()
        button.config(text: "Диктофон", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
        return button
    }()
    
    private lazy var player = PlayerView()
    
    private lazy var saveButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGreen") ?? .green)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension AudioViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.title = "Аудио"
    }
    
    func addSubviews() {
        [cutterLabel,
        cutterView,
        fileButton,
        recordButton,
        player,
        saveButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            cutterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cutterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cutterLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cutterLabel.heightAnchor.constraint(equalToConstant: 20),
            cutterView.topAnchor.constraint(equalTo: cutterLabel.bottomAnchor, constant: 30),
            cutterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cutterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cutterView.heightAnchor.constraint(equalToConstant: 30),
            fileButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            fileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            fileButton.topAnchor.constraint(equalTo: cutterView.bottomAnchor, constant: 30),
            recordButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            recordButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            recordButton.topAnchor.constraint(equalTo: fileButton.bottomAnchor, constant: 20),
            player.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            player.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            player.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.topAnchor.constraint(greaterThanOrEqualTo: player.bottomAnchor, constant: 20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            fileButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

