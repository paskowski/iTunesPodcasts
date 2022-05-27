import UIKit
import RxSwift

class PodcastCell: UITableViewCell {

    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var disposeBag = DisposeBag()

    static let reuseIdentifier = String(describing: self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: PodcastCellViewModel) {
        self.artistLabel.text = viewModel.artistName
        self.trackNameLabel.text = viewModel.trackName
        viewModel.imageDownloader
            .getImage(url: viewModel.artworkUrl)
            .asDriver(onErrorJustReturn: UIImage())
            .drive(artworkImageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func setupLayout() {
        [artworkImageView, artistLabel, trackNameLabel].forEach(contentView.addSubview)

        NSLayoutConstraint.activate([
            artworkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            artworkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            artworkImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            artworkImageView.widthAnchor.constraint(equalToConstant: 64),
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor),

            artistLabel.topAnchor.constraint(equalTo: artworkImageView.topAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 16),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            trackNameLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8),
            trackNameLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 16),
            trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            trackNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
