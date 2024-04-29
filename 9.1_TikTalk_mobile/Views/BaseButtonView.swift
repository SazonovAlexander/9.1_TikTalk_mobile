import UIKit


final class BaseButtonView: UIButton {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(text: String, backgroundColor: UIColor, isEnabled: Bool = true) {
        setTitle(text, for: .normal)
        self.backgroundColor = backgroundColor
        self.isEnabled = isEnabled
    }
}

private extension BaseButtonView {
    
    func setup() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        layer.cornerRadius = 12
    }
}
