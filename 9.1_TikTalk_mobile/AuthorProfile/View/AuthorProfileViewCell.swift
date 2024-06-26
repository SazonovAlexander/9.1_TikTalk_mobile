import UIKit


final class AuthorProfileViewCell: UITableViewCell {
    
    public static let reuseIdentifier = "AuthorProfileViewCell"
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
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
    
    func config(author: AuthorCell) {
        nameLabel.text = author.name
        logoImageView.kf.setImage(with: author.avatarUrl, placeholder: UIImage(named: "Logo"))
    }
}

private extension AuthorProfileViewCell {
    
    func setup() {
        backgroundColor = UIColor(named: "Background")
        selectionStyle = .none
        
        [logoImageView,
         nameLabel,
         arrowImageView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            logoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 8),
            arrowImageView.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
