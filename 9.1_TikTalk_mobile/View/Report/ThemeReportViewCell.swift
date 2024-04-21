import UIKit


final class ThemeReportViewCell: UITableViewCell {
    
    public static let reuseIdentifier = "ThemeReportViewCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(text: String) {
        label.text = text
    }
}

private extension ThemeReportViewCell {
    
    func setup() {
        backgroundColor = .clear
        
        [label,
         arrowImageView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

