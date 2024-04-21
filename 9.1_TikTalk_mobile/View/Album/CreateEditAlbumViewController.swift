import UIKit


final class CreateEditAlbumViewController: UIViewController {
    
    private lazy var nameTextField = ValidatedTextField(placeholder: "Название")
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.text = "Описание"
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
    
    private lazy var saveButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Сохранить", backgroundColor: .green)
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

private extension CreateEditAlbumViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    func addSubviews() {
        [nameTextField,
        descriptionLabel,
        textField,
        saveButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
