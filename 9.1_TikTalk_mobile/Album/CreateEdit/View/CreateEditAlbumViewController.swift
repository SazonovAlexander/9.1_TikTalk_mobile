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
        return button
    }()
    
    private let presenter: CreateEditAlbumPresenter
    
    init(presenter: CreateEditAlbumPresenter) {
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
    
    func config(_ album: AlbumInfo) {
        nameTextField.setText(album.name)
        textField.text = album.description
        nameTextField.validateAction?(true)
    }
    
    func exit() {
        navigationController?.popViewController(animated: true)
    }
}

private extension CreateEditAlbumViewController {
    
    func setup() {
        nameTextField.validateAction = {[weak self] result in
            if result {
                self?.saveButton.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGreen") ?? .green, isEnabled: true)
            } else {
                self?.saveButton.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGray") ?? .gray, isEnabled: false)
            }
        }
        nameTextField.validateAction?(false)
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
        hideKeyboardWhenTappedAround()
        presenter.getInfo()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.backButtonTitle = "Альбом"
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
        let nameTextFieldBottomAnchor = nameTextField.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor)
        let textFieldBottomAnchor = textField.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor)
        textFieldBottomAnchor.priority = .defaultHigh
        var constaintsLow = [
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ]
        constaintsLow.forEach({$0.priority = .defaultLow})
        var constraints = [
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 70),
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 300),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints + constaintsLow + [nameTextFieldBottomAnchor, textFieldBottomAnchor])
    }
    
    func addActions() {
        saveButton.addTarget(self, action: #selector(Self.didTapSaveButton), for: .touchUpInside)
    }
    
    @objc
    func didTapSaveButton() {
        print("save")
        let album = AlbumInfo(name: nameTextField.getText(), description: textField.text)
        presenter.save(album)
    }
}
