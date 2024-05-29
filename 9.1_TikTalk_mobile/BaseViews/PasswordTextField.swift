import UIKit


final class PasswordTextField: UIView {
    
    var action: ((String) -> Void)?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
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
    
    init() {
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

private extension PasswordTextField {
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        textField.rightView = clearButton
        textField.attributedPlaceholder = NSAttributedString(
            string: "Пароль",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        textField.addTarget(self, action: #selector(Self.actionTextField), for: .allEditingEvents)
        clearButton.addTarget(self, action: #selector(Self.clearText), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50),
            clearButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    @objc
    func clearText() {
        textField.text = nil
    }
    
    @objc
    func actionTextField() {
        action?(textField.text ?? "")
    }
}

