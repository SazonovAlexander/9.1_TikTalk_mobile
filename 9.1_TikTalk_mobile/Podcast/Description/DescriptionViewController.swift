import UIKit


final class DescriptionViewController: UIViewController {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.text = "Название подкаста" // название + альбом
        return label
    }()
    
    private lazy var descriptionText: UITextView = {
        let textView = UITextView()
        textView.text = "Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкастаОписание подкаста Описание подкастаОписание подкастам Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкастаОписание подкаста Описание подкастаОписание подкастам Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкастаОписание подкаста Описание подкастаОписание подкастам Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкастаОписание подкаста Описание подкастаОписание подкастам Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкастаОписание подкаста Описание подкастаОписание подкастам Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкастаОписание подкаста Описание подкастаОписание подкастам Описание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкастаОписание подкаста Описание подкаста Описание подкаста Описание подкаста Описание подкаста"
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension DescriptionViewController {
    
    func setup() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    func addSubviews() {
        [nameLabel,
         descriptionText].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            descriptionText.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            descriptionText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            descriptionText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
