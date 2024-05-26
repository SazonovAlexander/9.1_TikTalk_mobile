import UIKit


final class EditProfileViewController: UIViewController {
    
    private lazy var nameTextField = ValidatedTextField(placeholder: "Имя")
   
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var subsButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGreen") ?? .green)
        return button
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    private let presenter: EditProfilePresenter
    private var newImageUrl: URL?
    
    init(presenter: EditProfilePresenter) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }
    
    func config(profile: Profile) {
        nameTextField.setText(profile.name)
        avatarImageView.kf.setImage(with: profile.avatarUrl, placeholder: UIImage(named: "Logo"))
    }
    
    func exit() {
        dismiss(animated: true)
    }
}

private extension EditProfileViewController {
    
    func setup() {
        nameTextField.validateAction = {[weak self] result in
            if result {
                self?.subsButton.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGreen") ?? .green, isEnabled: true)
            } else {
                self?.subsButton.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGray") ?? .gray, isEnabled: false)
            }
        }
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
        hideKeyboardWhenTappedAround()
        presenter.getInfo()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    func addSubviews() {
        [nameTextField,
        avatarImageView,
        subsButton
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            subsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            subsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            subsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            subsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func addActions() {
        subsButton.addTarget(self, action: #selector(Self.didTapSaveButton), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Self.didTapImage))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didTapSaveButton() {
        presenter.save(newName: nameTextField.getText(), newImageUrl: newImageUrl)
    }
    
    @objc 
    func didTapImage() {
        present(imagePicker, animated: true, completion: nil)
    }
}


extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            avatarImageView.image = pickedImage
        }
        if let imageUrl = info[.imageURL] as? URL {
            newImageUrl = imageUrl
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
