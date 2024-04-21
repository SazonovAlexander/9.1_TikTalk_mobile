import UIKit


final class ReportViewController: UIViewController {
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "Имя профиля" //имя профиля
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var podcastNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "Название подкаста" //имя профиля
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var reportThemeButton: ThemeReportButton = {
        let button = ThemeReportButton()
        button.config(text: "Тема жалобы")
        return button
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.text = "Сообщение (необязательно)"
        label.numberOfLines = 1
        return label
    }()
    
    
    private lazy var textField: UITextView = {
        let textField = UITextView()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 24, weight: .regular)
        textField.backgroundColor = .clear
        return textField
    }()
    
    private lazy var sendButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Отправить", backgroundColor: .green)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

private extension ReportViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.title = "Жалоба"
    }
    
    func addSubviews() {
        [authorNameLabel,
        podcastNameLabel,
        reportThemeButton,
        messageLabel,
        textField,
        sendButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            authorNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            authorNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            authorNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            authorNameLabel.heightAnchor.constraint(equalToConstant: 40),
            podcastNameLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 10),
            podcastNameLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            podcastNameLabel.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
            podcastNameLabel.heightAnchor.constraint(equalToConstant: 40),
            reportThemeButton.topAnchor.constraint(equalTo: podcastNameLabel.bottomAnchor, constant: 10),
            reportThemeButton.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            reportThemeButton.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
            reportThemeButton.heightAnchor.constraint(equalToConstant: 40),
            messageLabel.topAnchor.constraint(equalTo: reportThemeButton.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
            textField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
            sendButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            sendButton.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            sendButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
