import UIKit


final class CreateEditPodcastViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var nameTextField = ValidatedTextField(placeholder: "Название")
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var audioButton: UIButton = {
        let button = BaseButtonView()
        button.config(text: "Аудио", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
        return button
    }()
    
    private lazy var selectAlbum: SelectButtonView = {
        let button = SelectButtonView()
        button.config(text: "Выбор альбома")
        return button
    }()
    
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
        button.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGreen") ?? .green)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension CreateEditPodcastViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.title = "Создание подкаста"
    }
    
    func addSubviews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [nameTextField,
        logoImageView,
        audioButton,
        selectAlbum,
        descriptionLabel,
        textField,
        saveButton
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.superview?.bottomAnchor ?? view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logoImageView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            audioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            audioButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            audioButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            selectAlbum.leadingAnchor.constraint(equalTo: audioButton.leadingAnchor),
            selectAlbum.trailingAnchor.constraint(equalTo: audioButton.trailingAnchor),
            selectAlbum.topAnchor.constraint(equalTo: audioButton.bottomAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: selectAlbum.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 250),
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            saveButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            audioButton.heightAnchor.constraint(equalToConstant: 50),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

