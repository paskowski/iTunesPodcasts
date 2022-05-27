import Foundation
import UIKit
import RxSwift

class PodcastDetailsViewController: UIViewController {

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

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let podcastDetailsViewModel: PodcastDetailsViewModel
    private let disposeBag = DisposeBag()

    init(podcastDetailsViewModel: PodcastDetailsViewModel) {
        self.podcastDetailsViewModel = podcastDetailsViewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }

    private func setupLayout() {
        [artworkImageView, artistLabel, trackNameLabel, releaseDateLabel].forEach(view.addSubview)

        NSLayoutConstraint.activate([
            artworkImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            artworkImageView.widthAnchor.constraint(equalToConstant: 192),
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor),
            artworkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            artistLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 32),
            artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            trackNameLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 32),
            trackNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            releaseDateLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 32),
            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupBindings() {
        podcastDetailsViewModel.imageDownloader
            .getImage(url: podcastDetailsViewModel.artworkUrl)
            .asDriver(onErrorJustReturn: UIImage())
            .drive(artworkImageView.rx.image)
            .disposed(by: disposeBag)

        artistLabel.text = podcastDetailsViewModel.artistName
        trackNameLabel.text = podcastDetailsViewModel.trackName
        releaseDateLabel.text = podcastDetailsViewModel.releaseDate
    }
}
