import RxSwift
import RxRelay

final class PodcastsSearchViewModel {

    private let podcastsLoader: PodcastsLoader
    private let imageDownloader: ImageDownloader
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter
    }()
    private let scheduler: SchedulerType

    init(podcastsLoader: PodcastsLoader, imageDownloader: ImageDownloader, scheduler: SchedulerType = MainScheduler.instance) {
        self.podcastsLoader = podcastsLoader
        self.imageDownloader = imageDownloader
        self.scheduler = scheduler
    }

    // Inputs

    let searchTextDidChangeRelay = PublishRelay<String>()
    let tappedCellIndexRelay = PublishRelay<Int>()

    // Outputs

    private var foundPodcasts: Observable<[Podcast]> {
        searchTextDidChangeRelay
            .skip(1)
            .throttle(.milliseconds(250), scheduler: scheduler)
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

    var navigateToDetailsScreen: Observable<PodcastDetailsViewModel> {
        tappedCellIndexRelay
            .withLatestFrom(foundPodcasts) { index, podcasts in
                podcasts[index]
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
