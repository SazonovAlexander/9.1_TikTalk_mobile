import UIKit
import Kingfisher


final class PodcastViewCell: UITableViewCell {
    
    public static let reuseIdentifier = "PodcastViewCell"
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(podcast: PodcastCell, separator: Bool = false) {
        nameLabel.text = podcast.name
        if let url = podcast.logoUrl {
            logoImageView.kf.setImage(with: url, placeholder: UIImage(named: "Logo"))
        }
        separatorView.isHidden = !separator
    }
}

private extension PodcastViewCell {
    
    func setup() {
        backgroundColor = UIColor(named: "Background")
        selectionStyle = .none
        
        [logoImageView,
         nameLabel,
         arrowImageView,
         separatorView].forEach{
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
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            
        ])
    }
}
