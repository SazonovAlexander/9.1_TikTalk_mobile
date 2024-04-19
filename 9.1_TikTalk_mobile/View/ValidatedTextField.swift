import UIKit


final class ValidatedTextField: UIView {
    
    var validateAction: ((Bool) -> Void)?
    
    private var isValid: Bool = false
    private let placeholder: String
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.backgroundColor = .background
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightViewMode = .whileEditing
        return textField
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        return button
    }()
    
    private lazy var validateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "Максимальная длина 35 символов"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getText() -> String {
        return textField.text ?? ""
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
}

private extension ValidatedTextField {
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        textField.rightView = clearButton
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        
        stack.addArrangedSubview(textField)
        stack.addArrangedSubview(validateLabel)
        addSubview(stack)
        
        textField.addTarget(self, action: #selector(Self.validateName), for: .allEditingEvents)
        clearButton.addTarget(self, action: #selector(Self.clearText), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75),
            clearButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    @objc
    func clearText() {
        textField.text = nil
        validateLabel.isHidden = true
        validateAction?(false)
    }
    
    @objc
    func validateName() {
        if let text = textField.text {
            let count = text.count
            var result = false
            if count > 35 {
                presentValidateLabel()
            }
            else {
                hideValidateLabel()
                if count != 0 {
                    result = true
                }
            }
            validateAction?(result)
        }
    }
    
    func hideValidateLabel() {
        validateLabel.isHidden = true
    }
    
    func presentValidateLabel() {
        validateLabel.isHidden = false
    }
}

