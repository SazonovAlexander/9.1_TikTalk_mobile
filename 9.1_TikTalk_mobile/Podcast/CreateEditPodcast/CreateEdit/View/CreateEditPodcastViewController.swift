import UIKit


final class CreateEditPodcastViewController: UIViewController {
    
    var completion: (() -> Void)?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    private lazy var nameTextField = ValidatedTextField(placeholder: "Название")
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var audioButton: BaseButtonView = {
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
        textField.delegate = self
        return textField
    }()
    
    var textFieldIsEditing: Bool = false
    var newDesc: String? = nil
    var newName: String? = nil
    var isEdit: Bool = false
    
    private lazy var saveButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGreen") ?? .green)
        return button
    }()
    
    private let presenter: CreateEditPodcastPresenter
    
    init(presenter: CreateEditPodcastPresenter) {
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
        completion?()
    }
    
    func config(_ podcast: PodcastInfo?, isEdit: Bool) {
        self.isEdit = isEdit
        if isEdit {
            audioButton.isHidden = true
            navigationItem.title = "Редактирование подкаста"
        }
        
       
        nameTextField.setText(podcast?.name ?? "")
        textField.text = podcast?.description ?? ""
        if presenter.logo != nil {
            logoImageView.kf.setImage(with: presenter.logo!, placeholder: UIImage(named: "Logo"))
        }
        audioButton.config(text: "Аудио", backgroundColor: presenter.audio != nil ? (UIColor(named: "ButtonGreen") ?? .green) : (UIColor(named: "ButtonGray") ?? .gray))
        selectAlbum.config(text: presenter.album?.name ?? "Выбор альбома")
        nameTextField.validateAction?(presenter.isValid())
    }
    
    func exit() {
        dismiss(animated: true)
    }
}

private extension CreateEditPodcastViewController {
    
    func setup() {
        nameTextField.validateAction = {[weak self] result in
            guard let self else { return }
            if result && self.presenter.isValid() {
                self.saveButton.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGreen") ?? .green, isEnabled: true)
            } else {
                self.saveButton.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGray") ?? .gray, isEnabled: false)
            }
        }
        nameTextField.validateAction?(false)
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
        hideKeyboardWhenTappedAround()
        addKeyboardObservers()
        presenter.getInfo()
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if textFieldIsEditing {
            scrollView.scrollRectToVisible(textField.frame, animated: true)
        } else {
            scrollView.scrollRectToVisible(nameTextField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldIsEditing = false
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.title = "Создание подкаста"
        navigationItem.backButtonTitle = "Назад"
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
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 70),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 90),
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
            audioButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func addActions() {
        audioButton.addTarget(self, action: #selector(Self.didTapAudioButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(Self.didTapSaveButton), for: .touchUpInside)
        selectAlbum.addTarget(self, action: #selector(Self.didTapAlbumButton), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Self.didTapImage))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didTapAudioButton() {
        presenter.selectAudio()
    }
    
    @objc
    func didTapSaveButton() {
        let podcast = PodcastInfo(name: nameTextField.getText(), description: newDesc ?? textField.text)
        presenter.save(podcast)
    }
    
    @objc
    func didTapAlbumButton() {
        presenter.selectAlbum()
    }
    
    @objc
    func didTapImage() {
        present(imagePicker, animated: true, completion: nil)
    }
}


extension CreateEditPodcastViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            logoImageView.image = pickedImage
        }
        if let imageUrl = info[.imageURL] as? URL {
            presenter.logo = imageUrl
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateEditPodcastViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textFieldIsEditing = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textFieldIsEditing = false
        if isEdit {
            newDesc = textView.text
        }
    }
}
