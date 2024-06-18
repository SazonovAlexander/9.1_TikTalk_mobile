import UIKit
import WebKit

final class AuthViewController: UIViewController {
    
    var completion: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Вход"
        return label
    }()
    
    private lazy var nameTextField = ValidatedTextField(placeholder: "Логин")
    
    private lazy var passwordTextField = PasswordTextField()
    
    private lazy var registrationButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Регистрация", backgroundColor: UIColor(named: "ProfileButtonBackgorund") ?? .blue)
        return button
    }()
    
    private lazy var loginButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Вход", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
        button.isEnabled = false
        return button
    }()
    
    private var nameIsValid: Bool = false {
        didSet {
            validation(nameTextFiledValid: nameIsValid, passwordTextFiledValid: passIsValid)
        }
    }
    private var passIsValid: Bool = false {
        didSet {
            validation(nameTextFiledValid: nameIsValid, passwordTextFiledValid: passIsValid)
        }
    }
    
    private let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        completion?()
    }
}

private extension AuthViewController {
    
    func setup() {
        view.backgroundColor = UIColor(named: "Background")
        addSubviews()
        activateConstraints()
        
        nameTextField.validateAction = { [weak self] isValid in
            self?.nameIsValid = isValid
        }
        passwordTextField.action = { [weak self] text in
            self?.passIsValid = text.count > 5
        }
        hideKeyboardWhenTappedAround()
        addActions()
    }
    
    func addSubviews() {
        [titleLabel,
        nameTextField,
        passwordTextField,
        registrationButton,
        loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            nameTextField.heightAnchor.constraint(equalToConstant: 70),
            passwordTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            registrationButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            registrationButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
            registrationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func validation(nameTextFiledValid: Bool, passwordTextFiledValid: Bool) {
        if nameTextFiledValid && passwordTextFiledValid {
            loginButton.config(text: "Вход", backgroundColor: UIColor(named: "ButtonGreen") ?? .green)
            loginButton.isEnabled = true
        } else {
            loginButton.config(text: "Вход", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
            loginButton.isEnabled = false
        }
    }
    
    func addActions() {
        registrationButton.addTarget(self, action: #selector(Self.tapRegButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(Self.tapAuthButton), for: .touchUpInside)
    }
    
    @objc
    func tapRegButton() {
        self.navigationItem.title = "Вход"
        self.navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
    @objc
    func tapAuthButton() {
        let auth = AuthRequest(username: nameTextField.getText(), password: passwordTextField.getText())
        
        authService.auth(auth: auth) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let auth):
                TokenStorage.shared.accessToken = auth.accessToken
                TokenStorage.shared.refreshToken = auth.refreshToken
                self.dismiss(animated: true)
            case .failure(let error):
                self.showErrorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}
