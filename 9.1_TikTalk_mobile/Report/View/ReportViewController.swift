import UIKit


final class ReportViewController: UIViewController {
    
    private var presenter: ReportPresenter
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var podcastNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var reportThemeButton: SelectButtonView = {
        let button = SelectButtonView()
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
        textField.delegate = self
        return textField
    }()
    
    private lazy var sendButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Выберите тему", backgroundColor: UIColor(named: "ButtonGray") ?? .gray, isEnabled: false)
        return button
    }()
    
    private var report: Report?
    
    init(presenter: ReportPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if TokenStorage.shared.accessToken == "" {
            showAuthController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func config(authorName: String, podcastName: String, theme: String?) {
        authorNameLabel.text = authorName
        podcastNameLabel.text = podcastName
        if let theme {
            reportThemeButton.config(text: theme)
            report = Report(theme: theme, message: textField.text)
            sendButton.config(text: "Отправить", backgroundColor: UIColor(named: "ButtonGreen") ?? .green, isEnabled: true)
        }
    }
    
    func exit() {
        dismiss(animated: true)
    }
}

private extension ReportViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
        hideKeyboardWhenTappedAround()
        presenter.getInfo()
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
        let constraints = [
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
            textField.heightAnchor.constraint(equalToConstant: 300),
            textField.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor),
            sendButton.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let constraintsLow = [
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            authorNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        constraintsLow.forEach({$0.priority = .defaultLow})
        NSLayoutConstraint.activate(constraints + constraintsLow)
    }
    
    func addActions() {
        sendButton.addTarget(self, action: #selector(Self.didTapSendButton), for: .touchUpInside)
        reportThemeButton.addTarget(self, action: #selector(Self.didTapSelectThemeButton), for: .touchUpInside)
    }
    
    @objc
    func didTapSendButton() {
        if let report {
            presenter.sendReport(report)
        }
    }
    
    @objc
    func didTapSelectThemeButton() {
        presenter.selectTheme()
    }
}

extension ReportViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        report?.message = textView.text
    }
}
