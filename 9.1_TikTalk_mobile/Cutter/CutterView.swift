import UIKit


final class LimiterView: UIView {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 1
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


final class CutterView: UIView {
    
    private lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var middleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var leftLimiter = LimiterView()
    private lazy var rightLimiter = LimiterView()
    
    private var leftLimiterConstraint: NSLayoutConstraint!
    private var rightLimiterConstraint: NSLayoutConstraint!
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CutterView {
    
    func setup() {
        backgroundColor = .clear
        
        [leftView,
        middleView,
        rightView,
        leftLimiter,
        rightLimiter].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        leftLimiterConstraint = leftView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
        leftLimiterConstraint.priority = .defaultLow
        rightLimiterConstraint = rightView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
        rightLimiterConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            leftView.heightAnchor.constraint(equalToConstant: 5),
            middleView.heightAnchor.constraint(equalToConstant: 5),
            rightView.heightAnchor.constraint(equalToConstant: 5),
            leftLimiter.heightAnchor.constraint(equalToConstant: 20),
            rightLimiter.heightAnchor.constraint(equalToConstant: 20),
            leftLimiter.widthAnchor.constraint(equalToConstant: 10),
            rightLimiter.widthAnchor.constraint(equalToConstant: 10),
            leftLimiter.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLimiter.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftView.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftView.leadingAnchor.constraint(equalTo: leadingAnchor),
            middleView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor),
            middleView.trailingAnchor.constraint(equalTo: rightView.leadingAnchor),
            rightView.trailingAnchor.constraint(equalTo: trailingAnchor),
            leftLimiter.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            leftLimiter.centerXAnchor.constraint(equalTo: leftView.trailingAnchor),
            rightLimiter.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            rightLimiter.centerXAnchor.constraint(equalTo: rightView.leadingAnchor),
            rightView.leadingAnchor.constraint(greaterThanOrEqualTo: leftView.trailingAnchor),
            leftLimiterConstraint,
            rightLimiterConstraint
        ])
    }
}
