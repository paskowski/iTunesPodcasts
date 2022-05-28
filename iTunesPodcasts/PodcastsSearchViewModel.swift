import RxSwift
import RxRelay

class PodcastsSearchViewModel {

    private let podcastsLoader: PodcastsLoader
    private let imageDownloader: ImageDownloader
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter
    }()

    init(podcastsLoader: PodcastsLoader, imageDownloader: ImageDownloader) {
        self.podcastsLoader = podcastsLoader
        self.imageDownloader = imageDownloader
    }

    let searchTextDidChangeRelay = PublishRelay<String>()

    private var foundPodcasts: Observable<[Podcast]> {
        searchTextDidChangeRelay
            .skip(1)
            .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap {
                self.podcastsLoader.loadPodcasts(for: $0)
            }
            .share()
    }

    var podcastsCellsViewModels: Observable<[PodcastCellViewModel]> {
        foundPodcasts
            .map { [imageDownloader] podcasts in
                podcasts.map {
                    PodcastCellViewModel(
                        artistName: $0.artistName,
                        trackName: $0.trackName,
                        artworkUrl: $0.artworkUrlThumbnail,
                        imageDownloader: imageDownloader
                    )
                }
            }
    }

    let tappedCellIndexPathRelay = PublishRelay<IndexPath>()

    var navigateToDetailsScreen: Observable<PodcastDetailsViewModel> {
        tappedCellIndexPathRelay
            .withLatestFrom(foundPodcasts) { indexPath, podcasts in
                podcasts[indexPath.row]
            }
            .map { [imageDownloader, dateFormatter] in
                PodcastDetailsViewModel(
                    artistName: $0.artistName,
                    trackName: $0.trackName,
                    artworkUrl: $0.artworkUrlDetail,
                    releaseDate: dateFormatter.string(from: $0.releaseDate),
                    imageDownloader: imageDownloader
                )
            }
    }
}
