import UIKit
import WebKit

final class RegistrationViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Регистрация"
        return label
    }()
    
    private lazy var nameTextField = ValidatedTextField(placeholder: "Имя")
    
    private lazy var loginTextField = ValidatedTextField(placeholder: "Логин")
    
    private lazy var passwordTextField = PasswordTextField()
    
    private lazy var registrationButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Регистрация", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
        button.isEnabled = false
        return button
    }()
    
    private var nameIsValid: Bool = false {
        didSet {
            validation(nameTextFiledValid: nameIsValid, passwordTextFiledValid: passIsValid, loginTextFieldValid: loginIsValid)
        }
    }
    private var passIsValid: Bool = false {
        didSet {
            validation(nameTextFiledValid: nameIsValid, passwordTextFiledValid: passIsValid, loginTextFieldValid: loginIsValid)
        }
    }
    private var loginIsValid: Bool = false {
        didSet {
            validation(nameTextFiledValid: nameIsValid, passwordTextFiledValid: passIsValid, loginTextFieldValid: loginIsValid)
        }
    }
    
    private let registerService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = ""
    }
}

private extension RegistrationViewController {
    
    func setup() {
        view.backgroundColor = UIColor(named: "Background")
        addSubviews()
        activateConstraints()
        
        nameTextField.validateAction = { [weak self] isValid in
            self?.nameIsValid = isValid
        }
        loginTextField.validateAction = { [weak self] isValid in
            self?.loginIsValid = isValid
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
        loginTextField,
        passwordTextField,
        registrationButton
        ].forEach {
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
            loginTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            loginTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            loginTextField.heightAnchor.constraint(equalToConstant: 70),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            registrationButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            registrationButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            registrationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            registrationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func validation(nameTextFiledValid: Bool, passwordTextFiledValid: Bool, loginTextFieldValid: Bool) {
        if nameTextFiledValid && passwordTextFiledValid && loginTextFieldValid {
            registrationButton.config(text: "Регистрация", backgroundColor: UIColor(named: "ButtonGreen") ?? .green)
            registrationButton.isEnabled = true
        } else {
            registrationButton.config(text: "Регистрация", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
            registrationButton.isEnabled = false
        }
    }
    
    func addActions() {
        registrationButton.addTarget(self, action: #selector(Self.tapRegButton), for: .touchUpInside)
    }
    
    @objc
    func tapRegButton() {
        let register = Register(
            username: loginTextField.getText(),
            password: passwordTextField.getText(),
            firstName: nameTextField.getText(),
            email: loginTextField.getText() + "@tiktalk.com"
        )
        
        registerService.register(register: register) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.showErrorAlert(title: "Ошибка", message: "Проверьте соединение")
            }
        }
    }
}
